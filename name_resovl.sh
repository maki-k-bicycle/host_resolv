#!/bin/bash 

cmd=""
dlist="8.8.8.8 9.9.9.9 9.9.9.10 1.1.1.1"
date=`date +%Y%m%d`
cnt="01"
fqdn="google.com"
opt=""
logs="./logs"
i="array"
 
#logファイルが1個以上存在する場合、末尾の一番大きい番号をカウントアップして新規作成
#事前にログの宣言が必要最大999個作成可能
 
function lg_exst_chck () {
        for cnt in `seq -f %03g 1 999`
        do
            if
                [ ! -f $logs${cnt}.log ];then
                logs=$logs${cnt}.log
                break
            fi
        done
}
 
#helpを呼び出す

function cmd_hlp () {

                echo "This script use
host command - DNS lookup utility"
                echo "OPTIONS"
                echo "-t a     FQDN answer A Record."
                echo "-t ptr   FQDN answer MX Record."
                echo "-t mx    FQDN answer MX Record."
                echo "-t cname FQDN answer CNAME Record."
                echo "-t txt   FQDN answer TXT Record."
                echo "Example: $0 -t a
google.com"
}
 
#対話モード 
function intrctv_md () {

read -t 120 -p "Input name resolution host(default:$fqdn): " fqdn
 
        case "$fqdn" in
                "") fqdn=google.com
                        ;;
                *)
                        ;;
        esac

read -t 120 -p "Input name resolution zone <<A,PTR,MX,TXT,ALL>>(default:None):" opt

        case "$opt" in

             A ) opt="-t a"
                        ;;
           PTR ) opt="-t ptr"
                        ;;
            MX ) opt="-t mx"
                        ;;
           TXT ) opt="-t txt"
                        ;;
           ALL ) opt="-a"
                        ;;
            "" ) opt=""
                        ;;
              *) echo -e "Cannot
understand your answer.\nRetype name resolution zone \n"
                        exit 0
                        ;;
        esac
}

#hostコマンド実行　事前に$cmdにコマンドを格納する必要あり

function cmd_md () {
        for i in $dlist
        do
                echo "##### name server$i "
                echo "##### $cmd $i"
                $cmd $i
        done > $logs

        echo -e "\ncreate name resoluton result.\nlooking for current directory.\nfile: $logs"
}
 
#以下実行処理
 
#logsディレクトリがない場合作成

[ ! -e $logs ] && mkdir -p  $logs
if  [ "$1" = "-h" ] || [ "$1" = "--help" ]
        then

cmd_hlp

        elif
 
        [ $# = 0 ]
        then
intrctv_md

logs="./logs/resolv_"$date"_"$fqdn"_"
 
lg_exst_chck

opt="$opt $fqdn"
cmd="host $opt"

cmd_md
        elif
        [ "$1" != "-t" ]
        then
                echo -e "Error! Invalidarguments!\nRun "$0 -h" and try again!"
        else
logs="./logs/resolv_"$date"_"$3"_" 

lg_exst_chck 

cmd="host $@" 
cmd_md
fi
