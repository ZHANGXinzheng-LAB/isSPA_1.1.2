#pragma once

#include <fstream>
#include <string>
#include <unordered_map>
#include <variant>
#include <vector>
#include <iostream>

using namespace std::string_literals;

template <class... Ts> struct overloaded : Ts... {
  using Ts::operator()...;
};
template <class... Ts> overloaded(Ts...) -> overloaded<Ts...>;

struct Config {
  using Node = std::variant<int, float, std::string>;
  std::unordered_map<std::string, Node> value{
      // requested
      {"input", ""s},
      {"template", ""s},
      {"template_dims", 2},
      {"eulerfile", ""s},
      {"angpix", -1.0f},
      {"phistep", -1.0f},
      {"kk", -1.0f},
      {"energy", -1.0f},
      {"cs", -1.0f},
      {"Highres", -1.0f},
      {"Lowres", .0f},
      {"diameter", -1.0f},
      // optional
      {"threshold", 7.0f},
      {"output", ""s},
      {"first", 0},
      {"last", 0},
      {"GPU_ID", -1},
      {"window_size", 320},
      {"phase_flip", 0},
      {"overlap", 0},
      {"norm_type", 0},
      {"invert", 0},
  };

  std::string& gets(const std::string& key) { return std::get<std::string>(value[key]); }
  const std::string& gets(const std::string& key) const { return std::get<std::string>(value.at(key)); }
  int& geti(const std::string& key) { return std::get<int>(value[key]); }
  const int& geti(const std::string& key) const { return std::get<int>(value.at(key)); }
  float& getf(const std::string& key) { return std::get<float>(value[key]); }
  const float& getf(const std::string& key) const { return std::get<float>(value.at(key)); }

  void print() {
    for (auto&& [name, val] : value) {
      std::cout << name << " = ";
      std::visit(overloaded{
                     [](auto arg) { std::cout << arg << ' '; },
                     [](float arg) { std::cout << std::fixed << arg << ' '; },
                     [](const std::string& arg) { std::cout << arg << ' '; },
                 },
                 val);
      std::cout << std::endl;
    }
  }

  // Parse from config file
  Config(const std::string& path);

  // Check all requested para
  void checkRequestPara();
};

struct Parameters {
  float apix{}, kk{}, energy{}, cs{}, highres{}, lowres{}, d_m{}, thresh{};
  float lambda{}, dfu{}, dfv{}, ds{}, defocus{}, dfdiff{}, dfang{};
  float edge_half_width{4.0f}, ampconst{0.07f};
  float a{-10.81f}, b{1.f}, b2{0.32f}, bfactor{-18.17f}, bfactor2{-15.22f}, bfactor3{1.72f};

  Parameters() = default;
  Parameters(const Config& c)
      : apix(c.getf("angpix")), kk(c.getf("kk")), energy(c.getf("energy")), cs(c.getf("cs")), highres(c.getf("Highres")),
        lowres(c.getf("Lowres")), d_m(c.getf("diameter")), thresh(c.getf("threshold")) {}
};

struct EulerData {
  std::vector<float> euler1, euler2, euler3;

  EulerData() = default;
  EulerData(const std::string& eulerf);
  size_t size() const { return euler1.size(); };
};

struct LST {
  struct Entry {
    int unused;
    std::string rpath;
    double defocus;
    double dfdiff;
    double dfang;
  };

  static std::vector<Entry> load(const std::string& lst_path);
  static void print(const std::vector<Entry>& lst);
};