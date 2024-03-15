The input data files are stored in the ./data/original folder.  This can be stored somewhere else with a simlink or stored locally with the specified subdirectory tree.  Similarly, large intermediate files can be produced from ARQMath-3 code into the prepro_2022, extracted, indexed, queried directories which could also be a simlink.

ln -s LOCATION data

mkdir data

ln -s LOCATION data/original
ln -s LOCATION data/processed
ln -s LOCATION data/index
ln -s LOCATION data/results

mkdir data/original
mkdir data/processed
mkdir data/index
mkdir data/results

These folders should store the MathStackExchange (MSE) data used in ARQMath.  The instruction to download the files can be found from the official ARQMath page.
*Note that "V1.0" is also used for the Comment file, which is an older version.
*Note that the first four files have been gzipped for space savings.

- data/original/Comments.V1.0.xml.gz
- data/original/Comments.V1.3.xml.gz
- data/original/PostLinks.V1.3.xml.gz
- data/original/Posts.V1.3.xml.gz

- data/original/latex_representation_v3 (folder)
- data/original/slt_representation_v3 (folder)
- data/original/opt_representation_v3 (folder)

- data/original/Topics_V2.0.xml
- data/original/Formula_topics_latex_V2.0.tsv
- data/original/Formula_topics_slt_V2.0.tsv
- data/original/Topics_Task1_2021_V1.1.xml
- data/original/Topics_2021_Formulas_Latex_V1.1.tsv
- data/original/Topics_2021_Formulas_OPT_V1.1.tsv
- data/original/Topics_2021_Formulas_SLT_V1.1.tsv
- data/original/Topics_Task1_2022_V0.1.xml
- data/original/Topics_Formulas_Latex.V0.1.tsv
- data/original/Topics_Formulas_OPT.V0.1.tsv
- data/original/Topics_Formulas_SLT.V0.1.tsv

- data/original/qrel_official_task1
- data/original/qrel_task1_2021_test.tsv
- data/original/qrel_task1_2022_official.tsv

- data/original/Topics_V1.1.xml
- data/original/Topics_Task2_2021_V1.1.xml
- data/original/Topics_Task2_2022_V0.1.xml

- data/original/qrel_task2_2020.tsv					#Note: unsure where this file came from.
- data/original/qrel_task2_2021_test_official_evaluation.tsv
- data/original/qrel_task2_2022_official.tsv

