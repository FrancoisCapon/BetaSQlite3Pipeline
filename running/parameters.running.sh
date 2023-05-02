# sqlite3 parameters
# export sqlite3_output_mode='table'
export sqlite3_setup=".mode box\n.bail on\nPRAGMA foreign_keys = ON;\n.width 10 10 10 \n"

export style_successful='\e[92mSuccessful'
export style_failed='\e[91mFailed'
export style_pipeline='\e[1;94m'
export style_stage='\e[1;94m + '
export style_step='\e[1;94m | \e[0;95m'
export style_failed_code='\e[38:5:248m'

export nl_options="--body-numbering=a --number-format=rz --number-width=3 --number-separator='.  '"

# export failed_sql_pattern="'\| 0[ ]+\|'"
export failed_sql_pattern="'ASSERT_FAIL'"
export failed_egrep_options="-A 9999 -B 9999 --color=always"
export failed_egrep_colors="cx=90:mt=0;91:sl=0;33"

# m4
# https://stackoverflow.com/questions/13842575/gnu-m4-strip-empty-liness
export m4_bootstrap="divert(\`-1')\nchangequote([,])"

# 4 dev
echo -e "\e[31mWARNING: DEV => rm log and tmp"
rm -f $pipeline_directory/log/*
rm -f $pipeline_directory/tmp/*