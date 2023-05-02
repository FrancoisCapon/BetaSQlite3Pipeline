cd populate
commands=$sqlite3_setup"PRAGMA foreign_keys = OFF;\n"
while read -r level
do
    for table in $level
    do
        csv="$table.csv"
        imports=$imports".import --csv $csv $table\n"
    done
done < levels.tud
# import csv and handle not null
if [ -f import-after.sql ]
then
    import_after=$(cat import-after.sql)"\n"
fi
commands=$commands$imports$import_after
echo -e "$commands" | sqlite3 $database 2>&1
exit=$?
if (( $exit == 0))
then
    commands=$sqlite3_setup"PRAGMA foreign_key_check;"
    echo -e "$commands"
    foreign_key_check=$(echo -e "$commands" | sqlite3 $database 2>&1)
    exit=$?
    if (( $exit == 0))
    then
        exit=$(echo -n -e "$foreign_key_check" | wc -l)
        if (( $exit != 0 ))
        then
            echo -n -e "$foreign_key_check"
        fi
    fi
else
    echo -e "$commands" | eval nl $nl_options
fi
cd ..
# exit 1
exit $exit