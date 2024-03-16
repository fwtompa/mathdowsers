# Data layout for the mathdowser system

## Creating the subdirectory structure for the data

The mathdowser system requires data to be stored in the following subdirectories:

- data/original (prerequisite data that is externally provided)
- data/processed (intermediate files that are generated somewhere along the execution pipeline)
- data/index (index files used by the seach engine)
- data/results (output files resulting from queries and evaluation files that measure effectiveness or efficiency)

The data itself can be stored remotely and accessed through a simlink or (some of) the tree can stored locally with simlinks used for those subdirectories (if any) to be stored remotely.
If the whole data tree is to be remote, use the command:

  ```
    ln -s LOCATION data
  ```

where LOCATION is the remote location for the data tree. If some of the tree is to be stored locally, use the command:

  ```
    mkdir data
  ```

In the latter case, if any subtree is to be stored remotely, use:

  ```
    ln -s LOCATION data/original
    ln -s LOCATION data/processed
    ln -s LOCATION data/index
    ln -s LOCATION data/results
  ```

as appropriate; and if they are to be stored locally, use instead:

  ```
    mkdir data/original
    mkdir data/processed
    mkdir data/index
    mkdir data/results
  ```

## Initial data requirements

Externally-produced data files are stored in the data/original subdirectory, which must be populated with the expected data before executing the processing pipeline.

### ARQMath benchmark data

The benchmark's data files can be found from the official ARQMath page, last seen at
[Data and Tools](https://www.cs.rit.edu/~dprl/ARQMath/arqmath-resources.html).
Because the mathdowsers data organization is much simpler than that of the ARQMath site, the required files must be found by browsing that site to locate the following files to download and place in data/original.

- (from Collections:)
  - data/original/Comments.V1.0.xml.gz
  - data/original/Comments.V1.3.xml.gz
  - data/original/PostLinks.V1.3.xml.gz
  - data/original/Posts.V1.3.xml.gz
  - *Note that these first four files must also be gzipped when storing them in data/original.*
- (from Formulas:)
  - data/original/latex_representation_v3 (subdirectory)
  - data/original/slt_representation_v3 (subdirectory)
  - data/original/opt_representation_v3 (subdirectory)
- (from Topics:)
  - (for Task 1:)
    - (for ARQMath-1:)
      - data/original/Topics_V2.0.xml
      - data/original/Formula_topics_latex_V2.0.tsv
      - data/original/Formula_topics_opt_V2.0.tsv
      - data/original/Formula_topics_slt_V2.0.tsv
    - (for ARQMath-2:)
      - data/original/Topics_Task1_2021_V1.1.xml
      - data/original/Topics_2021_Formulas_Latex_V1.1.tsv
      - data/original/Topics_2021_Formulas_OPT_V1.1.tsv
      - data/original/Topics_2021_Formulas_SLT_V1.1.tsv
    - (for ARQMath-3:)
      - data/original/Topics_Task1_2022_V0.1.xml
      - data/original/Topics_Formulas_Latex.V0.1.tsv
      - data/original/Topics_Formulas_OPT.V0.1.tsv
      - data/original/Topics_Formulas_SLT.V0.1.tsv
    - (for Task 1 evaluations:)
      - data/original/qrel_official_task1
      - data/original/qrel_task1_2021_test.tsv
      - data/original/qrel_task1_2022_official.tsv
  - (for Task 2:)
    - data/original/Topics_V1.1.xml
    - data/original/Topics_Task2_2021_V1.1.xml
    - data/original/Topics_Task2_2022_V0.1.xml
    - (for Task 2 evaluations:)
      - data/original/qrel_task2_2020.tsv			(*???? unsure of the file on ARQMath site*)
      - data/original/qrel_task2_2021_test_official_evaluation.tsv
      - data/original/qrel_task2_2022_official.tsv

### Other data

- (for stopwords:)
- (for *mathy* words:)
