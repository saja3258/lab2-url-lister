#!/usr/bin/env python3
"""
URLMapper.py - Extracts URLs from HTML href attributes
This mapper finds all href="url" patterns and emits each URL with count 1
"""

import sys
import re

def main():
    # Regex pattern to match href="anything_here"
    # This captures the URL inside the quotes
    url_pattern = re.compile(r'href="([^"]*)"', re.IGNORECASE)
    
    # Process each line from standard input
    for line in sys.stdin:
        # Remove whitespace from beginning and end
        line = line.strip()
        
        # Find all URLs in this line
        urls = url_pattern.findall(line)
        
        # Emit each URL with count 1
        for url in urls:
            if url.strip():  # Only emit non-empty URLs
                # Output format: URL<TAB>1
                print(f"{url}\t1")

if __name__ == "__main__":
    main()
