# Copyright (c) Jordan Carlin, Harvey Mudd College.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# typed: false
# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "tmpdir"
require "fileutils"
require "pathname"

class TestCfgHeaders < Minitest::Test
  REPO_ROOT = (Pathname.new(__dir__) / ".." / ".." / ".." / "..").realpath
  GOLDEN_DIR = REPO_ROOT / "tests" / "data" / "golden"
  UDB_GEN = (REPO_ROOT / "bin" / "udb-gen").to_s
  TEST_CONFIG = "mc100-32-full-example"

  def setup
    @gen_dir = Dir.mktmpdir
  end

  def teardown
    FileUtils.rm_rf(@gen_dir)
  end

  def test_cfg_c_header_matches_golden
    output_path = File.join(@gen_dir, "#{TEST_CONFIG}.h")
    golden_path = GOLDEN_DIR / "#{TEST_CONFIG}.golden.h"

    out, err, status = Open3.capture3(
      UDB_GEN, "cfg-c-header",
      "-c", TEST_CONFIG,
      "-o", output_path
    )

    assert status.success?, "udb-gen cfg-c-header failed:\nstdout: #{out}\nstderr: #{err}"

    expected = File.read(golden_path.to_s)
    actual = File.read(output_path)
    assert_equal expected, actual,
      "C header output doesn't match golden reference.\n" \
      "If this is expected, run:\n" \
      "  ./do chore:update_golden_cfg_headers"
  end

  def test_cfg_svh_header_matches_golden
    output_path = File.join(@gen_dir, "#{TEST_CONFIG}.svh")
    golden_path = GOLDEN_DIR / "#{TEST_CONFIG}.golden.svh"

    out, err, status = Open3.capture3(
      UDB_GEN, "cfg-svh-header",
      "-c", TEST_CONFIG,
      "-o", output_path
    )

    assert status.success?, "udb-gen cfg-svh-header failed:\nstdout: #{out}\nstderr: #{err}"

    expected = File.read(golden_path.to_s)
    actual = File.read(output_path)
    assert_equal expected, actual,
      "SystemVerilog header output doesn't match golden reference.\n" \
      "If this is expected, run:\n" \
      "  ./do chore:update_golden_cfg_headers"
  end
end
