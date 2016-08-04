public:

// declare a return value overloadable, multi return value enabled method
template declare(string signature, string Body) {
  string declare() {
    string returnTypesString, signatureString;

	// simple workaround, so that i don't have to parse the function signature to get the return values
    splitInTwo(signature, "<=", returnTypesString, signatureString);

    auto returnTypes = returnTypesString.split(",");

    auto prefix = "";
    if (hasArguments(signatureString)) {
      prefix = ", ";
    }
    
	// create the out arguments for the return values
    auto arguments = "";
    foreach (i, returnType; returnTypes) {
      returnType = returnType.strip();
      arguments ~= prefix ~ "out " ~ returnType.strip() ~ " R" ~ resultVariablePrefix ~ i.to!string;
      prefix = ", ";
    }
    
	// replace return statements with assignments to the out arguments
    string bodyString = "";
    foreach(line; Body.split("\n")) {
      if (line.strip.startsWith("return")) {
        auto returnStatements = line.remove("return").remove(";").strip().split(",");
        foreach(i, statement; returnStatements) {
          bodyString ~= "R" ~ resultVariablePrefix ~ i.to!string ~ " = " ~ statement.strip() ~ ";\n";
        }
        bodyString ~= "return;\n";
      } else {
        bodyString ~= line ~ "\n";
      }
    }

	// recombine the new signature and body
    return "void " ~ signatureString.strip().replace(")", arguments ~ ")") ~ " {" ~ bodyString ~ "}";
  }
}

template call(string functionCall) {
  string call() {
    string returnValuesString, functionCallString;
    splitInTwo(functionCall, "=", returnValuesString, functionCallString);
    auto returnValues = returnValuesString.strip.split(",");
    
    auto prefix = "";
    if (hasArguments(functionCallString)) {
      prefix = ", ";
    }

    string[string] declarations;
    
    auto arguments = "";
    foreach (value; returnValues) {
      value = value.strip();
      if (value.indexOf(" ") > -1) {
        string name, type;
        splitInTwo(value, " ", type, name);
        declarations[name] = type;
        arguments ~= prefix ~ name;
      } else {
        arguments ~= prefix ~ value;
      } 
      prefix = ", ";
    }

    auto prolog = "\n";

    foreach(name, type; declarations) {
      prolog ~= type ~ " " ~ name ~ ";\n";
    }

    return prolog ~ functionCallString.replace(")", arguments ~ ");");
  }
}

private:
import std.string;
import std.conv;

// check if there are already any arguments between the parantheses
bool hasArguments(string signature) {
  auto start = signature.indexOf("(") + 1;
  auto end = signature.indexOf(")") -1;
  foreach(i; start..end) {
    if (signature[i] != ' ') {
      return true;
    }
  }
  return false;
}

string remove(string input, string searchString) {
  return input.replace(searchString, "");
}

void splitInTwo(string input, string splitString, out string res1, out string res2) {
  auto tmp = input.split(splitString);
  res1 = tmp[0];
  res2 = tmp[1];
}

// Just for the sake of it, randomize the return value name so no one can mess with it :)
// All credits go to the author:
// http://forum.dlang.org/post/suswwamqwdszocvkvjbc@forum.dlang.org
import ctRNG;
enum resultVariablePrefix = xorShift!().stringof[0..5];