#!/usr/bin/env bash

streamfile="teststream"
tooldir="../bin" # smfa2 and read_write_stream binary location

if [ $# -ne 3 ]
then
	echo "usage: ./stirmark_test <testfile> <samplerate> <channels>"
	exit 1
fi

# read command line args
testfile=$1
samplerate=$2
channels=$3

# run attack with these params on the file
attack_list=(	"AddDynNoise:20"
				"AddNoise:100"
				"AddNoise:500"
				"AddNoise:900"
				"AddSinus:900 1300"
				"Amplify:50"
				"Compressor:-6.123 2.1"
				"CopySample:10 6 1"
				"CutSamples:10 1"
				"Echo:10"
				"Echo:50"
				"Exchange"
				"ExtraStereo:30"
				"ExtraStereo:50"
				"ExtraStereo:70"
				"FFT_Invert:16384"
				"FFT_RealReverse:16384"
				"FlippSample:10 2 6"
				"FlippSample:1000 600 200"
				"Invert"
				"RC_LowPass:9000"
				"Smooth"
				"Smooth2"
				"Stat1"
        		"ZeroCross:1000"
        		"ZeroLength:10"		
			)
			
# first convert the audio file to a stream
$tooldir/read_write_stream -f $testfile -c $channels > $streamfile
 
# run all attacks and convert results to audiofiles
for attack in "${attack_list[@]}" ; do
    attack_name=${attack%%:*}
    attack_param=${attack#*:}
    $tooldir/smfa2 --$attack_name $attack_param -s $samplerate < $streamfile | $tooldir/read_write_stream -p -s $samplerate -c $channels -f ${testfile%.wav}-attacked-$attack_name-${attack_param// /-}.wav
done

# cleanup
rm $streamfile
