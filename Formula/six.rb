class Six < Formula
  include Language::Python::Virtualenv

  desc "Python 2 and 3 compatibility utilities"
  homepage "https://pypi.python.org/pypi/six"
  url "https://github.com/benjaminp/six/archive/1.12.0.tar.gz"
  sha256 "0ce7aef70d066b8dda6425c670d00c25579c3daad8108b3e3d41bef26003c852"

  revision 1

  head "https://github.com/benjaminp/six.git", :branch => "master"

  bottle do
    root_url "https://dl.bintray.com/homebrew-osgeo/osgeo-bottles"
    cellar :any_skip_relocation
    sha256 "ecb39cc150f8a54cbc2bafa3dca562826baa39bf6bb3787d19fdb68101e4cd07" => :mojave
    sha256 "ecb39cc150f8a54cbc2bafa3dca562826baa39bf6bb3787d19fdb68101e4cd07" => :high_sierra
    sha256 "ecb39cc150f8a54cbc2bafa3dca562826baa39bf6bb3787d19fdb68101e4cd07" => :sierra
  end

  depends_on "python@2"
  depends_on "python"
  depends_on "tcl-tk"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c2/f7/c7b501b783e5a74cf1768bc174ee4fb0a8a6ee5af6afa92274ff964703e0/setuptools-40.8.0.zip"
    sha256 "6e4eec90337e849ade7103723b9a99631c1f0d19990d6e8412dc42f5ae8b304d"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/41/f8/507d1f6121293a0392f5d0850c138d9c7dac6d22f575734078da2d0f447c/pytest-4.2.0.tar.gz"
    sha256 "65aeaa77ae87c7fc95de56285282546cfa9c886dc8e5dc78313db1c25e21bc07"
  end

  def install
    ["python2", "python3"].each do |python|
      xy = Language::Python.major_minor_version python
      ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python#{xy}/site-packages"

      resource("setuptools").stage do
        system python, "setup.py", "install", "--prefix=#{libexec}", "--single-version-externally-managed", "--record=installed.txt"
      end

      resource("pytest").stage do
        system python, "setup.py", "install", "--prefix=#{libexec}", "--single-version-externally-managed", "--record=installed.txt"
      end

      ENV.prepend_create_path "PYTHONPATH", "#{lib}/python#{xy}/site-packages"
      system python, "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt", "--optimize=1"

      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    end
  end

  test do
    # TODO
  end
end
