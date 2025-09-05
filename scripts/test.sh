#!/bin/bash

# Test script for freezed_result package

set -e

echo "🧪 Running tests for freezed_result package..."

# Check if dart is available
if ! command -v dart &> /dev/null; then
    echo "❌ Dart is not installed or not in PATH"
    exit 1
fi

echo "📦 Installing dependencies..."
dart pub get

echo "🔨 Generating code..."
dart run build_runner build --delete-conflicting-outputs

echo "🧹 Checking code formatting..."
dart format --output=none --set-exit-if-changed .

echo "🔍 Analyzing code..."
dart analyze

echo "🧪 Running specific tests..."
dart test test/result_test.dart test/result_extensions_test.dart

echo "🧪 Running all tests..."
dart test

echo "✅ All tests passed!"
echo "🚀 Ready for commit and push to develop branch"
