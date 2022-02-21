# dark-data
How to get papers from ARXIV!
## 1. Install Packages and Configure PyCall
First, we need to install the appropriate packages and make sure Julia is using the appropriate version of PyCall. To do this, open up a terminal or Gitbash window, cd into the dark-data directory, and run:
```
julia "./configure.jl"
```

## 2. Getting Papers!
Probably the easiest way to do this is from the Julia repl. If you are familiar with the Julia repl, open one up and skip ahead, if you are not I will explain now. Open up a terminal/command prompt and cd into the dark-data directory. This will create an interactive window where you can type Julia code and run functions and still retain variables in memory!

Now that we have the repl, run:
```
include(pwd()*"/get_papers.jl")
```
This will give you access to all of the functionality in the get_papers.jl file within your repl.

### Example
To see an example of how it works, run:
```
example()
```
in the repl.

### Use

To get papers of your own, you want to use the retrieve_texts function. While there are a couple optional arguments, the required two are the most important.
- query_string: This is an API query structured in the specified ARXIV API format. For more information on that format, see this link: https://arxiv.org/help/api/user-manual#query_details.
- num_results: The maximum number of results you want for your query.

A function call would look something like:
```
retrieve_texts("quantum", 10)
```
