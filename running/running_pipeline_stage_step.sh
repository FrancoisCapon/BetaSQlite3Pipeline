step_file=$1
step_name=${step_file##*/}
step_type=${step_name##*.}
step_name=${step_name%.step.*}

if [ -f $step_name.parameters.sh ]
then
    source $step_name.parameters.sh
fi


#echo -e '\n    CODE BEGIN:\t'$step_name $step_type ; echo
# https://www.baeldung.com/linux/remove-blank-lines-from-file
#tac $step_file | sed '/\S/,$!d' | tac | cat -n
#cat -n $step_file
#echo -e '\n    CODE END:\t'$step_name $step_type
#echo -e '\n    EXEC BEGIN:\t'$step_name $step_type ; echo

case $step_type in
    sql)
        call_input="$sqlite3_setup\n$(cat $step_file)"
        if [[ $call_input == *"ASSERT_"* ]]
        then # m4
            call_input="$(echo -e "$m4_bootstrap$m4_macros\ndivert(1)\n$call_input" | m4 2>&1)"
        fi
        call_exit=$?
        if (( $call_exit == 0 ))
        then
            call_output=$(echo -e "$call_input" | sqlite3 $database 2>&1)
            call_exit=$?
        else # pb m4
            call_output=$call_input
            call_input="$(echo -e "$m4_bootstrap$m4_macros\ndivert(1)\n$sqlite3_setup\n$(cat $step_file)")"
        fi
    ;;
    sh)
        call_input="$(cat $step_file)"
        call_output=$(./$step_file)
        call_exit=$?
    ;;
    populate)
        call_input=$step_type
        call_output=$(running_pipeline_stage_step_populate.sh)
        call_exit=$?
    ;;
    *)
        echo "PIPELINE ERROR: unknow step type .$step_type in $@ at line $LINENO"
        exit 1
esac

# echo -e "\n$run"
# echo
# echo -e $( echo -e "$run" | grep --color=always -A 9999 -B 9999 'Error' )
# echo

# failed_pattern
if (( $call_exit == 0 ))
then
    case $step_type in
    sql|populate)
        echo -e "$call_output" | eval egrep $failed_sql_pattern > /dev/null ; egrep_exit=$?
        # https://www.gnu.org/software/grep/manual/grep.html#Exit-Status-1
        # Normally the exit status is 0 if a line is selected, 1 if no lines were selected, and 2 if an error occurred. 
        if (( $egrep_exit == 1 ))
        then
            step_exit=0
            step_status=$style_successful
        else
            step_exit=1
            step_status=$style_failed
        fi
    ;;
    sh)
        step_exit=0
        step_status=$style_successful
    ;;
    *)
        echo "PIPELINE ERROR: unknow step type .$step_type in $@ at line $LINENO"
        exit 1
    esac
    #step_exit=0
    #step_status=$style_successful
else
    step_status=$style_failed
    step_exit=1
    egrep_exit=1
fi

echo -e $style_step"STEP STATUS:\t"$step_status'\t'$step_name.step.$step_type'\e[39m'
if (( $step_exit != 0 ))
then
    if (( $egrep_exit == 0 ))
    then
        export GREP_COLORS=$failed_egrep_colors
        echo -e "\n$call_output\n" | eval egrep $failed_egrep_options $failed_sql_pattern
    else
        echo -e "\n$call_output\n"
        #eval "nl $nl_options <(echo $call_input)"
        echo -e "$style_failed_code"
        echo -e "$call_input" | eval nl $nl_options
        echo -e "\e[0m"
    fi
fi

exit $step_exit

