#!/bin/bash
# 按照 tex2marp 规则，将 blackhole thermaldynamics.tex 按每 15 个 frame 分割成 to-convert-n.tex 文件

INPUT="blackhole thermaldynamics.tex"
FRAME_STARTS=($(grep -n "begin{frame}" "$INPUT" | cut -d: -f1))
FRAME_ENDS=($(grep -n "end{frame}" "$INPUT" | cut -d: -f1))
TOTAL_FRAMES=${#FRAME_STARTS[@]}

FRAMES_PER_FILE=15
TOTAL_PARTS=$(( (TOTAL_FRAMES + FRAMES_PER_FILE - 1) / FRAMES_PER_FILE ))

for ((i=0; i<$TOTAL_PARTS; i++)); do
    PART_START_IDX=$((i * FRAMES_PER_FILE))
    PART_END_IDX=$(( (i+1) * FRAMES_PER_FILE - 1 ))
    if [ $PART_END_IDX -ge $((TOTAL_FRAMES)) ]; then
        PART_END_IDX=$((TOTAL_FRAMES - 1))
    fi
    START_LINE=${FRAME_STARTS[$PART_START_IDX]}
    END_LINE=${FRAME_ENDS[$PART_END_IDX]}
    if [ -z "$START_LINE" ] || [ -z "$END_LINE" ]; then
        continue
    fi
    sed -n "${START_LINE},${END_LINE}p" "$INPUT" > "to-convert-$((i+1)).tex"
done

echo "分割完成，共 $TOTAL_PARTS 个部分。"
