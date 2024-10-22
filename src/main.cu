#include <chrono>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <sstream>
#include <thread>

#include "DataReader2.h"
#include "helper.cuh"
#include "nonorm.cuh"
#include "norm.cuh"
#include "utils.h"

int main(int argc, char* argv[]) {
  try {
    Config conf(argv[1]);
    conf.print();

    auto lst = LST::load(conf.gets("input"));
    EulerData euler(conf.gets("eulerfile"));

    auto device = conf.geti("GPU_ID");
    std::printf("Selected device id %d\n", device);

    auto first = std::max(0, std::min(conf.geti("first"), int(lst.size() - 1)));
    auto last = std::min(conf.geti("last"), std::max(0, int(lst.size())));

    INIT_TIMEIT();

    Templates temp;
    std::printf("Read template: %s, ", conf.gets("template").c_str());
    TIMEIT(temp = Templates(conf.gets("template"), euler.size()));

    std::fstream output(conf.gets("output"), std::ios::out | std::ios::trunc);

    if (device != -1) {
      for (auto i = first; i < last; ++i) {
        const auto& entry = lst[i];
        if (conf.geti("norm_type")) {
          auto image = Image{entry};
          auto params = image.p;
          SearchNorm p(conf, euler, {params.width, params.height}, device);

          TIMEIT(p.work_verbose(temp, image, output); std::printf("Device %d finished in ", device););
        } else {
          SearchNoNorm p(conf, euler, {tile_size, tile_size}, device);
          auto tiles = TileImages{entry};
          TIMEIT(p.work_verbose(temp, tiles, output); std::printf("Device %d finished in ", device););
        }
      }
    } else {
      auto devcount = GetDeviceCount();
      std::printf("Device count: %d\n", devcount);
      auto intervals = work_intervals(first, last, devcount);

      std::vector<std::stringstream> ss(devcount);

      auto worker = [&](int device, std::pair<int, int> interval) {
        INIT_TIMEIT();
        std::stringstream output;
        for (auto i = interval.first; i < interval.second; ++i) {
          const auto& entry = lst[i];
          if (conf.geti("norm_type")) {
            auto image = Image{entry};
            auto params = image.p;
            SearchNorm p(conf, euler, {params.width, params.height}, device);

            p.work(temp, image, output);
          } else {
            SearchNoNorm p(conf, euler, {tile_size, tile_size}, device);
            auto tiles = TileImages{entry};
            TIMEIT(p.work(temp, tiles, output); std::printf("Device %d finished in ", device););
          }
        }
        ss[device] = std::move(output);
      };

      auto wcount = std::min(devcount, last - first);
      std::vector<std::thread> ts(wcount);
      for (auto dev = 0; dev < wcount; ++dev) {
        ts[dev] = std::thread(worker, dev, intervals[dev]);
      }

      for (auto& t : ts) {
        t.join();
      }

      for (const auto& s : ss) {
        output << s.rdbuf();
      }
    }
  } catch (const std::exception& e) {
    std::cout << e.what() << std::endl;
    std::exit(-1);
  }

  return 0;
}