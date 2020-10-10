class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-2.4.tar.gz"
  sha256 "ccc4105b3dc51c82b0f194499979be22d5a14504f741115be155bd991ee93cfa"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/olafvdspek/ctemplate.git"

  bottle do
    cellar :any
    sha256 "450518a03eec232531f67655c372b5be4cdb9d35d532d7a8941863f74a45bca2" => :catalina
    sha256 "37f5073fec13f28f3869c6e80d89c9a8659e9fad4fecc30721abe964f927ddff" => :mojave
    sha256 "6f0e5b78eab78861361f4a4e27cb264ce33d641c71c5981950bb28209205cb1d" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.9" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <ctemplate/template.h>
      int main(int argc, char** argv) {
        ctemplate::TemplateDictionary dict("example");
        dict.SetValue("NAME", "Jane Doe");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lctemplate_nothreads", "test.cpp", "-o", "test"
    system "./test"
  end
end