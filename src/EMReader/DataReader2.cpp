#include <cassert>

#include "DataReader2.h"

// Parse config file
Config::Config(const std::string& path) {
  std::ifstream conf(path);
  if (!conf) {
    printf("Open config file failed: %s\n\n", path.c_str());
    return;
  }
  std::string key, e, val;
  while (conf >> key >> e >> val) {
    assert(e == "=");

    if (this->value.find(key) == this->value.end())
      continue;

    std::visit(overloaded{
                   [&](auto& arg) { arg = val; },
                   [&](int& arg) { arg = std::stoi(val); },
                   [&](float& arg) { arg = std::stof(val); },
                   [&](std::string& arg) { arg = val; },
               },
               this->value[key]);
  }
  checkRequestPara();
}

void Config::checkRequestPara() {
  if (std::get<std::string>(value["input"]).empty())
    printf("Error : lst/star file is requested.\n");
  if (std::get<std::string>(value["template"]).empty())
    printf("Error : template file is requested.\n");
  if (std::get<std::string>(value["eulerfile"]).empty())
    printf("Error : euler file is requested.\n");
  if (std::get<float>(value["angpix"]) < 0)
    printf("Error : angpix is requested.\n");
  if (std::get<float>(value["phistep"]) < 0)
    printf("Error : phistep is requested.\n");
  if (std::get<float>(value["kk"]) < 0)
    printf("Error : kk is requested.\n");
  if (std::get<float>(value["energy"]) < 0)
    printf("Error : energy is requested.\n");
  if (std::get<float>(value["cs"]) < 0)
    printf("Error : cs is requested.\n");
  if (std::get<float>(value["Highres"]) < 0)
    printf("Error : highres is requested.\n");
  if (std::get<float>(value["Lowres"]) < 0)
    printf("Error : lowres is requested.\n");
  if (std::get<float>(value["diameter"]) < 0)
    printf("Error : diameter is requested.\n");
}

EulerData::EulerData(const std::string& eulerf) {
  std::ifstream eulerfile(eulerf);
  if (!eulerfile) {
    printf("Open euler file failed: %s\n\n", eulerf.c_str());
    return;
  }
  // float x, y, z;
  // while (eulerfile >> x >> y >> z) {
  //   this->euler1.push_back(x);
  //   this->euler2.push_back(y);
  //   this->euler3.push_back(z);
  // }
  float alt, az, phi;
  std::string line;
  while (std::getline(eulerfile, line)) {
    if (sscanf(line.c_str(), "%*f %f %f %f", &alt, &az, &phi) == 3 ||
        sscanf(line.c_str(), "%f %f %f", &alt, &az, &phi) == 3 ||
        sscanf(line.c_str(), "%*d %*s %f %f %f", &alt, &az, &phi) == 3) {
        this->euler1.push_back(alt);
        this->euler2.push_back(az);
        this->euler3.push_back(phi);
    }
  }
}

std::vector<LST::Entry> LST::load(const std::string& lst_path) {
  std::ifstream lstfile{lst_path};
  if (!lstfile) {
    printf("Open LST file failed: %s\n\n", lst_path.c_str());
    return {};
  }

  std::vector<Entry> ret;
  std::string tmp;
  Entry e;
  while (std::getline(lstfile, tmp)) {
    if (tmp.length()) {
      if (tmp[0] == '#') continue;
    }
    char buf[1024] = {'\0'};
    std::sscanf(tmp.c_str(), "%d %1023s defocus=%lf dfdiff=%lf dfang=%lf", &e.unused, buf, &e.defocus, &e.dfdiff, &e.dfang);
    e.rpath = std::string{buf};
    ret.emplace_back(std::move(e));
  }

  return ret;
}

void LST::print(const std::vector<LST::Entry>& lst) {
    for (auto&& e : lst) {
        std::printf("%d %s defocus=%lf dfdiff=%lf dfang=%lf\n", e.unused, e.rpath.c_str(), e.defocus, e.dfdiff, e.dfang);
    }
}
