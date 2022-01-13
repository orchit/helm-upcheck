#!/bin/bash


#read file
IFS=$'\n', read -d '' -a ARR < $1

OK=0
OLD=0
DEPRECATED=0
ITEMCOUNT=0

if [ "No releases found" = "${ARR[0]}" ]; then
  echo "# No helm chart installed!"
else
  #Calculate size for each column (varies, depending on the data...)
  re="^([^ ]+ [^ ]+[\t\ ]*)([^ ]+ [^ ]+[\t\ ]*)([^ ]+[ ]+)([^ ]+[ ]+)([^ ]+[ ]+)([^ ]+[ ]+)([^ ]+[ ]+)([^ ]+)$"
  [[ "${ARR[0]}" =~ $re ]] && var1="${BASH_REMATCH[1]}" && var2="${BASH_REMATCH[2]}" && var3="${BASH_REMATCH[3]}" && var4="${BASH_REMATCH[4]}"&& var5="${BASH_REMATCH[5]}" && var6="${BASH_REMATCH[6]}" && var7="${BASH_REMATCH[7]}"
  LEN1=${#var1}
  LEN2=${#var2}
  LEN3=${#var3}
  LEN4=${#var4}
  LEN5=${#var5}
  LEN6=${#var6}
  LEN7=${#var7}
  #Skip header
  ARR=("${ARR[@]:1}")

  #Regex to parse data rows
  re="^(.{$LEN1})(.{$LEN2})(.{$LEN3})(.{$LEN4})(.{$LEN5})(.{$LEN6})(.{$LEN7})(.*)$"


  for i in "${ARR[@]}"
  do
    [[ "${i}" =~ $re ]] && v1="${BASH_REMATCH[1]}" && v2="${BASH_REMATCH[2]}" && v3="${BASH_REMATCH[3]}" && v4="${BASH_REMATCH[4]}"&& v5="${BASH_REMATCH[5]}"&& v6="${BASH_REMATCH[6]}"&& v7="${BASH_REMATCH[7]}"&& v8="${BASH_REMATCH[8]}"
    #clean trailing blanks
    v1="${v1%"${v1##*[![:space:]]}"}"
    v2="${v2%"${v2##*[![:space:]]}"}"
    v3="${v3%"${v3##*[![:space:]]}"}"
    v4="${v4%"${v4##*[![:space:]]}"}"
    v5="${v5%"${v5##*[![:space:]]}"}"
    v6="${v6%"${v6##*[![:space:]]}"}"
    v7="${v7%"${v7##*[![:space:]]}"}"
    v8="${v8%"${v8##*[![:space:]]}"}"

    ITEMCOUNT=$((ITEMCOUNT+1))

    if [ "$v7" = "true" ]; then
      OLD=$((OLD+1))
      IS_OLD=1
    else
      OK=$((OK+1))
      IS_OLD=0
    fi
    if [ "$v8" = "true" ]; then
      DEPRECATED=$((DEPRECATED+1))
      IS_DEPRECATED=1
    else
      IS_DEPRECATED=0
    fi
    echo "# HELP upcheck_helm_item Data item for a helm release chart including the status if there is an update available (old) or if it's abandoned (deprecated)."
    echo "# TYPE upcheck_helm_item gauge"
    echo "upcheck_helm_item{release=\"$v1\",chart=\"$v2\",release_namespace=\"$v3\",helmversion=\"$v4\",installed=\"$v5\",latest=\"$v6\",old=\"$IS_OLD\",deprecated=\"$IS_DEPRECATED\"}  $((IS_OLD*1+IS_DEPRECATED*2))"
  done
fi
echo "# HELP upcheck_helm_items_total Number of scanned helm releases."
echo "# TYPE upcheck_helm_items_total counter"
echo "upcheck_helm_items_total ${ITEMCOUNT}"

echo "# HELP upcheck_helm_items_ok_total Number of scanned helm releases which are up 2 date."
echo "# TYPE upcheck_helm_items_ok_total counter"
echo "upcheck_helm_items_ok_total ${OK}"

echo "# HELP upcheck_helm_items_old_total Number of scanned helm releases which can be updated."
echo "# TYPE upcheck_helm_items_old_total counter"
echo "upcheck_helm_items_old_total ${OLD}"

echo "# HELP upcheck_helm_items_deprecated_total Number of scanned helm releases which are deprecated and should be replaced."
echo "# TYPE upcheck_helm_items_deprecated_total counter"
echo "upcheck_helm_items_deprecated_total ${DEPRECATED}"
