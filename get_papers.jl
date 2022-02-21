using PDFIO
using PyCall
arxiv = pyimport("arxiv")


# Make sure needed directories exist
if !isdir(pwd()*"/pdfs/")
    mkdir(pwd()*"/pdfs/")
end

if !isdir(pwd()*"/data/")
    mkdir(pwd()*"/data/")
end

function search_arxiv(query_string::String, num_results::Integer) # typing in Julia is optional
    """
    Uses Python arxiv library to access archive API

    query_string (str): query formatted in API format (https://arxiv.org/help/api/user-manual#query_details).
    num_results (int): number of results to return.

    return: ARXIV search object (http://lukasschwab.me/arxiv.py/index.html#Search).
    """
    search = arxiv.Search(
    query = query_string,
    max_results = num_results,
    sort_by = arxiv.SortCriterion.Relevance,
    sort_order = arxiv.SortOrder.Ascending,
    )
    return search
end

# function from https://github.com/sambitdash/PDFIO.jl
function get_PDF_data(src, out)
    """
    getPDFText(src, out) -> Dict
    - src - Input PDF file path from where text is to be extracted
    - out - Output TXT file path where the output will be written
    return - A dictionary containing metadata of the document
    """
    # handle that can be used for subsequence operations on the document.
    doc = pdDocOpen(src)

    # Metadata extracted from the PDF document.
    # This value is retained and returned as the return from the function.
    docinfo = pdDocGetInfo(doc)
    open(out, "w") do io

        # Returns number of pages in the document
        npage = pdDocGetPageCount(doc)

        for i=1:npage

            # handle to the specific page given the number index.
            page = pdDocGetPage(doc, i)

            # Extract text from the page and write it to the output file.
            pdPageExtractText(io, page)

        end
    end
    # Close the document handle.
    # The doc handle should not be used after this call
    pdDocClose(doc)
    return docinfo
end

function process_PDFs(pdf_path::String, data_folder::String)
    """
    Parses PDFs and turns them into txt files and saves them.

    pdf_path (str): Path where PDFs are stored.
    data_folder (str): path to where the txt files should be saved.
    """
    for file_name in readdir(pdf_path)
        get_PDF_data(pdf_path*file_name, replace(data_folder*file_name, ".pdf"=>".txt"))
    end
end

function save_pdfs(search, file_path::String)
    """
    Downloads and saves PDFs using ARXIV search results

    search: ARXIV search object (http://lukasschwab.me/arxiv.py/index.html#Search).
    file_path (string): Path where the PDFs will be saved.
    """
    # Iterate over results
    for result in search.results()
        result.download_pdf(dirpath=file_path,filename=replace(result.get_short_id()*".pdf", "/"=>"-" ))# save pdf where filename is Articles short ID
    end
end

function empty_pdfs(pdf_path::String)
    """
    Removes all PDFs in PDF path.

    pdf_path (str): Path where PDFs are stored.
    """
    for file_name in readdir(pdf_path)
        rm(pdf_path*file_name)
    end
end

function retrieve_texts(query_string::String, num_results::Int, data_folder=pwd()*"/data/"; keep_pdfs=true, pdf_path=pwd()*"/pdfs/")
    """
    Retrieves PDF(s) from ARXIV, turns them into text files, and saves them to a designated folder

    query_string (str): query formatted in API format (https://arxiv.org/help/api/user-manual#query_details).
    num_results (int): number of results to return.
    data_folder (str): path to where the txt files should be saved. Defaults to a folder called "data" within the dark-data directory.
    keep_pdfs (bool): whether or not the original PDFs should be saved. Defaults to true.
    pdf_path (str): Where the PDFs will be stored. Defaults to a folder called "pdfs" within the dark-data directory.
    """
    search = search_arxiv(query_string,num_results)
    save_pdfs(search, pdf_path)

    process_PDFs(pdf_path, data_folder)

    if !keep_pdfs
        empty_pdfs(pdf_path)
    end
end

function example()
    query_string = """quantum"""
    num_results = 10
    retrieve_texts(query_string, num_results)
end
