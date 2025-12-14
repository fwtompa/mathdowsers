# The mathdowsers project

The project goal is to improve MathIR. To this end, the project uses the ARQMath benchmark, which were developed as part of CLEF. 
This is a continuation of the [ARQMath mathdowser project](https://github.com/kiking0501/MathDowsers-ARQMath).

## Participants

- Andrew Kane
- Besat Kassaie
- Frank Tompa

Former participants:

- Dallas Fraser
- Yin Ki (Kiki) Ng

## Overview

Natural language mathematical questions, such as those found on Math Stack Exchange, can be automatically transformed into formal queries consisting of keywords and formulas.
The resulting formal queries can then be effectively executed against a corpus.
A key component of our approach has been to represent each formula as a bag of math features and to treat those features as simple search terms.
This approach can be adopted by any conventional, text-based search engine, including one developed recently to explore various aspects of search technology.

This code base includes three major processing steps used in our system:

1. query construction (converting natural language questions into formal queries by selecting and augmenting the text and formulas),
2. mapping formal queries to search terms (including suitable features to represent math formulas), and 
3. indexing and querying with the search engine (running queries efficiently and ranking results effectively).

We use data and queries from the ARQMath Labs, a benchmark based on a collection of questions and answers from Math Stack Exchange (MSE) between 2010 and 2018 consisting of approximately 1.1 million question-posts and 1.4 million answer-posts.
The main task presents experimenters with 100 mathematical questions (selected by the organizers from MSE question-posts in a subsequent year) and asks for ranked lists of potential answers among existing answer-posts in the collection.

In further work, we use responses from a large language model (LLM) to reformulate queries. Beyond simply replacing the query by the LLM response or concatenating the response to the query, we explore whether improvements accrue from the LLM *selecting* a subset of the query terms, *augmenting* the query with additional terms, or *re-weighting* the query terms. As a final step, we use *reciprocal rank fusion* to combine several component approaches in order to improve ranking results.

## Running the code

After cloning the repository, but before starting starting the execution pipeline, input data must be loaded  (see **README\_data.md**).
The following commands then execute portions of the pipeline:
  ```
    make corpus (create the database to be searched from the raw data provided by the ARQMath organizers)
    make index (create an index for that corpus to be used by the search engine)
    make queries (run the benchmark queries and performance evaluations)
  ```
**N.B. This was last run using Python 3.9.16. Also, LANG must not be set, and dbm must use the gdbm (dbm.gnu) backend database.**

## Next steps being pursued 

- Natural language text
   - Selection: improve keyword and keyphrase extraction
   - Summarization: use LLM to summarize documents and queries before searching
- Formulas
   - Representation: extract features from Content MathML (operator trees) as well as Presentation MathML (syntax layout trees)
   - Features: select most effective features from symbol layout and operator trees
- Execution 
   - Efficiency: implement  MaxScore dynamic pruning and split-lists
   - Effectiveness: support weighted fields in documents and queries

## References:

Andrew Kane, Yin Ki Ng, Frank Wm. Tompa. [Dowsing for Answers to Math Questions: Doing Better with Less](http://ceur-ws.org/Vol-3180/paper-03.pdf), in: CLEF 2022, volume 3180 of CEUR Workshop Proceddings, 2022.

Besat Kassaie, Andrew Kane, and Frank Wm. Tompa. [Exploiting Query Reformulation and Reciprocal Rank Fusion in Math-Aware Search Engines](https://dl.acm.org/doi/pdf/10.1145/3704268.3742687), in: DocEng 2025, 5:1-5:10. Earned *SIGWEB DocEng Best Paper Award*.

