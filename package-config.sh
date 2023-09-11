#! /bin/sh
# OpenWrt >= 21.02:


function _func_full_INST {
while :
do
  echo -e " \033[1;34自動フルインストールのスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-auto.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto.sh
          sh /etc/config-software/package-auto.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_choice_INST {
while :
do
  echo -e " \033[1;33m選択インストールのスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-manual.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-manual.sh
          sh /etc/config-software/package-manual.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_after_INST {
while :
do
  echo -e " \033[1;31mフラッシュ後にインストールしたパッケージ確認のスクリプトをダウンロードし実行します\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/install-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/install-config.sh
          sh /etc/config-software/install-config.sh
          read -p " 何かキーを押して下さい"
          break ;;
    "n" ) break ;;
  esac
done
}

OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;32mバージョンチェック: OK\033[0;39m"
else
 read -p " バージョンが違うため終了します"
 exit
fi

while :
do
  echo -e " \033[1;37mインストールは失敗する事があります\033[0;39m"
  echo -e " \033[1;37mpackage-config ---------------------------------------\033[0;39m"
  echo -e " \033[1;34m[f]\033[0;39m": 自動フルインストール（推奨パッケージオールイン）
  echo -e " \033[1;33m[c]\033[0;39m": 選択インストール
  echo -e " \033[1;31m[a]\033[0;39m": フラッシュ後にインストールしたパッケージ確認
  echo -e " \033[1;37m[q]\033[0;39m": 終了
  echo -e " \033[1;37m------------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [f/c/a or q]: " num 
  case "${num}" in
    "f" ) _func_full_INST ;;
    "c" ) _func_choice_INST ;;
    "a" ) _func_after_INST ;;
    "q" ) exit ;;
  esac
done
