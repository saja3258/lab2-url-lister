**Lab 2 - URL Lister Solution**

**Solution Description**

This solution implements a MapReduce program to count URL occurrences in a dataset using Python with Hadoop Streaming. The program consists of two components:

- **URLMapper.py**: Extracts URLs from input text and emits (URL, 1) pairs
- **URLReducer.py**: Aggregates counts for each URL and outputs URLs that appear more than 5 times

**Software Requirements**

- Python 3.x
- Hadoop with Streaming capability
- Google Cloud Platform Dataproc cluster

**Implementation Details**

**Mapper (URLMapper.py)**

- Reads input line by line
- Uses regular expressions to extract URLs
- Emits key-value pairs: (URL, 1)

**Reducer (URLReducer.py)**

- Receives sorted (URL, count) pairs
- Sums counts for each URL
- Outputs only URLs with count > 5

**Program Output**

The program successfully identified URLs appearing more than 5 times:

/wiki/Doi_(identifier) 18

/wiki/Google_File_System 6

/wiki/ISBN_(identifier) 18

/wiki/MapReduce 7

/wiki/Search_(identifier) 14

<http://example.com> 7

mw-data:TemplateStyles:r1219639374 7

mw-data:TemplateStyles:r1238218222 121

mw-data:TemplateStyles:r1295959781 53

mw-data:TemplateStyles:r886049734 12

**Execution Results**

**2-Worker Cluster Performance**

Cluster Configuration: 1 master + 2 workers

Execution Time: 1m30.998s

Real: 1m30.998s

User: 6m13.447s

Sys: 0m0.724s

**4-Worker Cluster Performance**

Cluster Configuration: 1 master + 4 workers

Execution Time: 1m7.265s

Real: 1m7.265s

User: 6m13.274s

Sys: 0m0.708s

**Performance Analysis**

The results show interesting performance characteristics when scaling from 2 to 4 workers:

**Performance Improvement:**

- **2-worker cluster**: 1m30.998s (90.998 seconds)
- **4-worker cluster**: 1m7.265s (67.265 seconds)
- **Improvement**: ~26% faster with double the workers

**Key Observations:**

- Doubling the workers did NOT halve the execution time, showing diminishing returns
- The improvement was only 26% despite 100% increase in workers
- User CPU time remained nearly identical (~6m13s), indicating consistent computational load
- System time was minimal and consistent between both runs

**Factors Limiting Scalability:**

- **Job overhead**: Cluster setup, coordination, and job management overhead doesn't scale with workers
- **Data size**: The dataset may not be large enough to fully utilize 4 workers efficiently
- **Network I/O**: Time spent reading from HDFS and writing results doesn't necessarily scale linearly
- **Sequential phases**: Job initialization and finalization phases don't benefit from additional workers

**Why Combiners Would Cause Problems**

The Java WordCount implementation uses a Combiner to improve efficiency by performing local aggregation. However, for this URL counting application, using a combiner could cause problems because:

1. **Partial aggregation loss**: If we only output URLs that appear >5 times in the combiner, we might lose URLs that appear ≤5 times locally but >5 times globally across all mappers.
2. **Threshold filtering**: The combiner would apply the ">5 occurrences" filter too early in the process, potentially eliminating URLs that should appear in the final output.
3. **Incorrect final counts**: URLs that appear exactly at the threshold might be inconsistently included or excluded depending on how they're distributed across different mappers.

The correct approach is to let all URL counts reach the reducer, then apply the filtering logic only at the final aggregation stage.

**Resources Used**

- Google Cloud Platform Dataproc
- Hadoop Streaming documentation

**Collaboration**

- Work was done independently, with the help of web to solve errors, steps and learning how to code.

**Files Included**

- URLMapper.py - Mapper implementation
- URLReducer.py - Reducer implementation
- Makefile - Build and execution scripts
- SOLUTION.md - This solution document