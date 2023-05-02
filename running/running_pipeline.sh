last_stage_name=$1
last_stage_directory=$last_stage_name.stage
last_stage=false

#source 00.parameters.sh

echo
echo -e $style_pipeline'PIPELINE BEGIN:\t'$pipeline_name

if [ ! -d tmp ]
then
    mkdir tmp
fi

export database="$(pwd)/tmp/$timestamp.sqlite"

if [ -f macros.pipeline.m4 ]
then
    export m4_macros="\n\n$(cat macros.pipeline.m4)"$m4_macros
fi

if [ -f parameters.pipeline.sh ]
then
    source parameters.pipeline.sh
fi

pipeline_status=$style_successful
pipeline_exit=0

chmod u+x */*.step.sh 2> /dev/null

# https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html
# When the pattern doesn't match, by default, it will remain unexpanded, so that's why we use the -e test to make sure the first thing in the match list exists.
shopt -s extglob
stages_directories=([1-9][0-9]-*.stage!(?*)) # end stage stage!(?*))
if [ -d "${stages_directories[0]}" ]
then
    for stage_directory in "${stages_directories[@]}"
    do
        if [ $stage_directory = $last_stage_directory ]
        then
            last_stage=true
        fi
        cd $stage_directory
        running_pipeline_stage.sh
        stage_exit=$?
        if (( $stage_exit > 0 ))
        then
            pipeline_status=$style_failed
            pipeline_exit=$stage_exit
            break
        fi
        cd ..
        if $last_stage
        then
            break
        fi
    done
fi

echo -e $style_pipeline'\nPIPELINE END:\t'$pipeline_status'\t'$pipeline_name".pipeline\e[39m\n"
exit $pipeline_exit