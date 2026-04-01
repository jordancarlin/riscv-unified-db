# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# typed: false
# frozen_string_literal: true

CFG_HEADERS_GOLDEN_DIR = $root / "tests" / "data" / "golden"
CFG_HEADERS_GEN_DIR = $root / "gen" / "cfg_headers"
CFG_HEADERS_TEST_CONFIG = "mc100-32-full-example"

directory CFG_HEADERS_GEN_DIR.to_s

namespace :test do
  desc "Check the cfg C header output vs. stored golden output"
  task :cfg_c_header => CFG_HEADERS_GEN_DIR.to_s do
    output = "#{CFG_HEADERS_GEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.h"
    golden = "#{CFG_HEADERS_GOLDEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.golden.h"

    sh "#{$root}/bin/udb-gen cfg-c-header -c #{CFG_HEADERS_TEST_CONFIG} -o #{output}"
    sh "diff -u #{golden} #{output}" do |ok, _res|
      if ok
        puts "PASSED"
      else
        warn <<~MSG

          The golden output for the cfg C header has changed. If this is expected, run:

            cp #{output} #{golden}
            git add #{golden}

          And commit.
        MSG
        exit 1
      end
    end
  end

  desc "Check the cfg SystemVerilog header output vs. stored golden output"
  task :cfg_svh_header => CFG_HEADERS_GEN_DIR.to_s do
    output = "#{CFG_HEADERS_GEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.svh"
    golden = "#{CFG_HEADERS_GOLDEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.golden.svh"

    sh "#{$root}/bin/udb-gen cfg-svh-header -c #{CFG_HEADERS_TEST_CONFIG} -o #{output}"
    sh "diff -u #{golden} #{output}" do |ok, _res|
      if ok
        puts "PASSED"
      else
        warn <<~MSG

          The golden output for the cfg SystemVerilog header has changed. If this is expected, run:

            cp #{output} #{golden}
            git add #{golden}

          And commit.
        MSG
        exit 1
      end
    end
  end
end

namespace :chore do
  desc "Update golden cfg header files"
  task :update_golden_cfg_headers => CFG_HEADERS_GEN_DIR.to_s do
    sh "#{$root}/bin/udb-gen cfg-c-header -c #{CFG_HEADERS_TEST_CONFIG} -o #{CFG_HEADERS_GEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.h"
    sh "#{$root}/bin/udb-gen cfg-svh-header -c #{CFG_HEADERS_TEST_CONFIG} -o #{CFG_HEADERS_GEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.svh"
    cp "#{CFG_HEADERS_GEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.h", "#{CFG_HEADERS_GOLDEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.golden.h"
    cp "#{CFG_HEADERS_GEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.svh", "#{CFG_HEADERS_GOLDEN_DIR}/#{CFG_HEADERS_TEST_CONFIG}.golden.svh"
  end
end
