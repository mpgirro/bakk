#!/usr/bin/env bash

streamfile="teststream"
tooldir="../bin"

if [ $# -ne 3 ]
then
	echo "usage: ./stirmark_test <testfile> <samplerate> <channels>"
	exit 1
fi

# read command line args
testfile=$1
samplerate=$2
channels=$3

# run these attack with these params on the file
attack_list=(	"AddNoise:100"
				"AddDynNoise:20"
        		"ZeroCross:1000"
        		"ZeroLength:10"
        		"Amplify:50" 
				"RC_LowPass:9000"
				"FFT_Invert:16384"
				"FFT_RealReverse:16384"
			)
			
# first convert the audio file to a stream
$tooldir/read_write_stream -f $testfile -c 1 > $streamfile
 
# run all attacks and convert results to audiofiles
for attack in "${attack_list[@]}" ; do
    attack_name=${attack%%:*}
    attack_param=${attack#*:}
    $tooldir/smfa2 --$attack_name $attack_param -s $samplerate < $streamfile | $tooldir/read_write_stream -p -s $samplerate -c 1 -f ${testfile%.wav}-attacked-$attack_name-$attack_param.wav
done


