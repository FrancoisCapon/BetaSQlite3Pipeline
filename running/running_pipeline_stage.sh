pwd=$(pwd)
stage_name=${pwd##*/}
stage_name=${stage_name%.stage}

if [ -f macros.stage.m4 ]
then
    export m4_macros="\n$(cat macros.stage.m4)"$m4_macros
fi

if [ -f parameters.stage.sh ]
then
    source parameters.stage.sh
fi

echo -e '\n'$style_stage'STAGE BEGIN:\t'$stage_name
stage_status=$style_successful
stage_exit=0

#source $stage_directory/00.parameters
#https://unix.stackexchange.com/questions/520744/test-if-any-files-that-do-not-match-a-specific-pattern-exist-in-a-directory
# When the pattern doesn't match, by default, it will remain unexpanded, so that's why we use the -e test to make sure the first thing in the match list exists. 
#shopt -s extglob
# steps_files=( [1-9][0-8]*.step.@(sql|sh) )
shopt -s extglob
steps_files=([1-9][0-9]-*.step.+([a-z])!(?*))
if [ -f "${steps_files[0]}" ]
then
    for step_file in "${steps_files[@]}"
    do
        running_pipeline_stage_step.sh $step_file
        step_exit=$?
        if (( $step_exit > 0 ))
        then
            stage_status=$style_failed
            stage_exit=$step_exit
            break
        fi
    done
fi
echo -e "$style_stage"'STAGE END:\t'$stage_status'\t'$stage_name'.stage\e[39m'
exit $stage_exit
