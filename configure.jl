using Pkg

function check_install_package(package_name::String)
    if  !(package_name in keys(Pkg.installed()))
        Pkg.add(package_name)
    end
end

ENV["PYTHON"]=Sys.which("python3")

check_install_package("PyCall")
check_install_package("PDFIO")
# check_install_package("JSON")

Pkg.build("PyCall")

using PDFIO, PyCall
# using JSON

println(PyCall.libpython)