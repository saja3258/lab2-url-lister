#!/usr/bin/env python3
"""
URLReducer.py - Sums URL counts and filters for count > 5
This reducer receives sorted URL/count pairs and outputs only URLs with total count > 5
"""

import sys

def main():
    current_url = None
    current_count = 0
    
    # Process each line from standard input
    for line in sys.stdin:
        # Remove whitespace
        line = line.strip()
        
        # Skip empty lines
        if not line:
            continue
        
        # Split the line into URL and count
        try:
            url, count = line.split('\t')
            count = int(count)
        except ValueError:
            # Skip malformed lines
            continue
        
        # If this is the same URL as before, add to count
        if current_url == url:
            current_count += count
        else:
            # We've moved to a new URL
            # Output the previous URL if count > 5
            if current_url is not None and current_count > 5:
                print(f"{current_url}\t{current_count}")
            
            # Start tracking the new URL
            current_url = url
            current_count = count
    
    # Don't forget to output the last URL if it qualifies
    if current_url is not None and current_count > 5:
        print(f"{current_url}\t{current_count}")

if __name__ == "__main__":
    main()
