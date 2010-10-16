#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include <cerrno>
#include <cstring>
#include <dirent.h>

using namespace std;

// Pastas tem como id de tipo 4.
const unsigned char FOLDER_TYPE = 4;

// Retorna o nome do arquivo sem a extensão.
string getPureFileName(const char*);
// Retorna o sufixo de acordo com a extensão.
string getSufix(const char*);
// Troca todas as ocorrências de uma string por outra em uma determinada string.
void replaceAll(const string&, const string&, string&);
// &
bool isValidFolder(const dirent*);
// &
bool isValidFile(const dirent*);
// Gera o arquivo .as com todos os arquivos do diretório.
bool generateActionScriptFile(const dirent*);

int main()
{
    string library = "package library\n{\n\timport flash.display.Sprite;\n\n\tpublic class Library extends Sprite\n\t{\n\t\tstatic public var classesNames:Array = new Array(";
    // Atualiza o errno.
    errno = 0;

    cout << endl << "#Welcome to the ResMaker v 1.0" << endl;

    // Abre o diretório e verifica se deu pau.
    DIR* directory = opendir(".");
    if (directory == NULL)
    {
        cout << "#Could not open the local directory" << endl << endl;
        return -1;
    }

    bool keepReading = true;
    // Enquanto há arquivos.
    while (keepReading)
    {
        // Lê o próximo arquivo.
        dirent* folder = readdir(directory);
        // Verifica se acabou ou deu pau.
        if (folder == NULL)
        {
            keepReading = false;
        }
        // Verifica se é uma pasta válida.
        else if (isValidFolder(folder))
        {
            library += getPureFileName(folder->d_name);
            library += ".getName(), ";
            // Gera o .as dessa pasta.
            keepReading = generateActionScriptFile(folder);
        }
        else
        {
            cout << "#Non valid folder readed: \"" << folder->d_name << "\" Ignoring it" << endl;
        }
    }

    library.erase(library.size() - 2, 2);
    library += ");\n\t}\n\n}";

    // Vê se há erros.
    if (errno > 0)
    {
        cout << "#An error has ocurred: " << strerror(errno) << endl << endl;
        return -1;
    }

    // Salvando Library.as
    ofstream outputFile("../src/library/Library.as");

    // Testa se deu certo.
    if (outputFile.is_open())
    {
        // Escreve no arquivo e fecha.
        outputFile << library;
        outputFile.close();
    }
    else
    {
        // Deu pau, retorna erro.
        cout << "#Could not save Library.as file" << endl << endl;
        return -1;
    }

    system("pause");

    return 0;
}

string getPureFileName(const char* name)
{
    string s = name;
    return s.substr(0, s.find_last_of('.'));
}

string getSufix(const char* name)
{
    string extension = name;
    unsigned int position = extension.find_last_of('.');

    if (position != string::npos)
        extension = extension.substr(extension.find_last_of('.'));

    if (extension == ".png" || extension == ".jpg" || extension == ".jpeg")
        return "Image";
    else if (extension == ".mp3")
        return "Sound";
    else if (extension == ".swf")
        return "Swf";
    else
        return "Info";
}

void replaceAll(const string& toReplace, const string& replacement, string& s)
{
    string buffer = "";

    size_t pos = string::npos;
    // Enquanto achar a string a ser trocada na string alvo, faz um replace nela.
    while ((pos = s.find(toReplace)) != string::npos)
        s = s.substr(0, pos) + replacement + s.substr(pos + toReplace.size());
}

bool isValidFolder(const dirent* folder)
{
    string folderName = folder->d_name;

    if (folderName.find(".") != string::npos || folderName == "Library" || folderName == "Fonts")
        return false;

    return true;
}

bool isValidFile(const dirent* file)
{
    string fileName = file->d_name;

    if (fileName == "." || fileName == ".." || fileName == ".svn")
        return false;

    return true;
}

bool generateActionScriptFile(const dirent* folder)
{
    // Abre o diretório e verifica se deu pau.
    DIR* directory = opendir(folder->d_name);
    if (directory == NULL)
    {
        cout << "#Could not open the folder " << folder->d_name << " in the local directory" << endl << endl;
        return false;
    }

    // Stream de saída.
    stringstream outputStream;

    // Cabeçalho da classe.
    outputStream << "﻿package library" << endl << "{" << endl << "+import flash.display.Sprite;" << endl << endl <<
            "+public class " << folder->d_name << " extends Sprite" << endl << "+{" << endl <<
            "++static public function getName():String { return \"" << folder->d_name << "\"; }" << endl << endl;

    bool keepReading = true;
    // Enquanto há arquivos.
    while (keepReading)
    {
        // Lê o próximo arquivo.
        dirent* file = readdir(directory);
        // Verifica se acabou ou deu pau.
        if (file == NULL)
            keepReading = false;
        else
        {
            // Checa se é um arquivo válido.
            if (!isValidFile(file))
                continue;

            // Gera o sufixo e gera o stream correto.
            string sufix = getSufix(file->d_name);

            outputStream << "++[Embed(source = \"../../lib/" << folder->d_name << "/" << file->d_name << "\"";
            if (sufix != "Info")
                outputStream << ")]" << endl;
            else
                outputStream << ", mimeType = \"application/octet-stream\")]" << endl;

            outputStream << "++static private var " << folder->d_name << getPureFileName(file->d_name) << sufix << ":Class;" << endl;
        }
    }

    // Rodapé da classe.
    outputStream << endl << "+}" << endl << "}" << endl;

    // Saída. Identando o código da classe.
    string output = outputStream.str();
    replaceAll("+", "    ", output);

    // Abre o arquivo de saída.
    string targetName = "../src/library/";
    targetName += folder->d_name;
    targetName += ".as";
    ofstream outputFile(targetName.c_str());

    // Testa se deu certo.
    if (outputFile.is_open())
    {
        // Escreve no arquivo e fecha.
        outputFile << output;
        outputFile.close();
    }
    else
    {
        // Deu pau, retorna erro.
        cout << "#Could not save target file" << endl << endl;
        return false;
    }

    return errno == 0;
}
