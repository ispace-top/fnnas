#!/bin/bash
#
# 从 NanoPC-T4 官方镜像提取 bootloader 文件
# 用法: ./extract-nanopc-t4-bootloader.sh
#

set -e

IMG_FILE="/mnt/d/fnos_Mainland-PE_arm_1.0.0_nanopc-t4_251.img"
OUTPUT_DIR="nanopc-t4-bootloader"
UBOOT_DIR="make-fnnas/u-boot/rockchip/nanopc-t4"

echo "========================================"
echo "NanoPC-T4 Bootloader 提取工具"
echo "========================================"
echo ""

# 检查镜像文件是否存在
if [ ! -f "$IMG_FILE" ]; then
    echo "错误: 镜像文件不存在: $IMG_FILE"
    echo "请修改脚本中的 IMG_FILE 变量为正确的路径"
    exit 1
fi

echo "镜像文件: $IMG_FILE"
echo "输出目录: $OUTPUT_DIR"
echo ""

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 提取 idbloader.bin
echo "[1/3] 提取 idbloader.bin..."
dd if="$IMG_FILE" of="$OUTPUT_DIR/idbloader.bin" bs=512 skip=64 count=1024 2>/dev/null
SIZE1=$(du -h "$OUTPUT_DIR/idbloader.bin" | cut -f1)
echo "✓ idbloader.bin 已提取 ($SIZE1)"

# 提取 uboot.img
echo "[2/3] 提取 uboot.img..."
dd if="$IMG_FILE" of="$OUTPUT_DIR/uboot.img" bs=512 skip=16384 count=8192 2>/dev/null
SIZE2=$(du -h "$OUTPUT_DIR/uboot.img" | cut -f1)
echo "✓ uboot.img 已提取 ($SIZE2)"

# 提取 trust.bin
echo "[3/3] 提取 trust.bin..."
dd if="$IMG_FILE" of="$OUTPUT_DIR/trust.bin" bs=512 skip=24576 count=8192 2>/dev/null
SIZE3=$(du -h "$OUTPUT_DIR/trust.bin" | cut -f1)
echo "✓ trust.bin 已提取 ($SIZE3)"

echo ""
echo "提取的文件："
ls -lh "$OUTPUT_DIR/"

echo ""
echo "========================================"
echo "复制到项目 U-Boot 目录"
echo "========================================"

# 创建 U-Boot 目录
mkdir -p "$UBOOT_DIR"

# 复制文件
cp -v "$OUTPUT_DIR"/* "$UBOOT_DIR/"

echo ""
echo "✓ 文件已复制到: $UBOOT_DIR/"
ls -lh "$UBOOT_DIR/"

echo ""
echo "========================================"
echo "提取完成！"
echo "========================================"
echo ""
echo "下一步："
echo "1. 验证文件大小是否合理："
echo "   - idbloader.bin: 应该在 300-500KB"
echo "   - uboot.img:     应该在 1-2MB"
echo "   - trust.bin:     应该在 1-2MB"
echo ""
echo "2. 如果文件大小正常，提交到 Git："
echo "   git add $UBOOT_DIR/"
echo "   git commit -m 'Add: NanoPC-T4 U-Boot bootloader 文件'"
echo "   git push origin main"
echo ""
