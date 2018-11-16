#!/bin/sh

jsonElm=$(cat elm.json)

deps=$(echo $jsonElm | jq -r '.dependencies.direct' | jq -r 'keys_unsorted[]')
depsVersions=$(echo $jsonElm | jq -r '.dependencies.direct[]')
depsVersionsArr=($depsVersions)

i=0
count=0
output=""
for dep in ${deps};
do
	releases=$(curl 'https://package.elm-lang.org/packages/'${dep}'/releases.json' 2>/dev/null |  jq -r 'keys[]')
	releasesArr=($releases)

	current=${depsVersionsArr[${i}]}
	last=${releasesArr[-1]}	
	i=$((i + 1))

	if [ $current != $last ] ;
	then
		output=`echo  "${output}${dep} ${current} ${last}\n"`
		count=$((count + 1))
	fi
done


echo -e $output | column --table --table-columns=Package,Old,New
echo Total packages checked: ${i}.
echo Total packages with newer version: ${count}.
