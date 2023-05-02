# $1 pipeline_name, directory ../pipeline_name.pipeline
# $2 last_stage_name,  directory ../pipeline_name.pipeline/last_stage_name.stage

export timestamp=$(date +%s)
export PATH="$(pwd)":$PATH
export pipeline_name=$1
pipeline_directory=../$pipeline_name.pipeline
#source 00.parameters.sh 2>&1 | tee -a ../log/"$timestamp".log
if [ -d $pipeline_directory ]
then
    clear
    if [ -f macros.running.m4 ]
    then
        export m4_macros="\n\n$(cat macros.running.m4)"
    fi
    source parameters.running.sh
    if [ ! -d $pipeline_directory/log ]
    then
        mkdir $pipeline_directory/log
    fi
    cd $pipeline_directory
    running_pipeline.sh $2 2>&1 | tee -a $pipeline_directory/log/"$timestamp".log
fi


# TODO : generer fichier SQL de test avec preprocesseur C

