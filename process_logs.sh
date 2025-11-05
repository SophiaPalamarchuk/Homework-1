#!/bin/bash

INPUT_FILE="app.log"
OUTPUT_FILE="app_fixed.log"

# Відомі рівні логування
LEVELS=("INFO" "ERROR" "FATAL" "NOTICE" "DEBUG" "TRACE" "WARNING")

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File '$INPUT_FILE' not found!"
    exit 1
fi

# Замінюємо WARNING -> ERROR
sed 's/\bWARNING\b/ERROR/g' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Replacement completed. Output saved to $OUTPUT_FILE"
echo
echo "Log level frequency after replacement (via grep):"
echo "----------------------------------------------------"

# Видобути саме 5-те поле (рівень)
cut -d ' ' -f5 "$OUTPUT_FILE" > /tmp/levels_only.tmp

# Рахуємо кожен рівень grep
for level in "${LEVELS[@]}"; do
    count=$(grep -w "$level" /tmp/levels_only.tmp | wc -l)
    if [[ $count -gt 0 ]]; then
        echo "$level: $count"
    fi
done
