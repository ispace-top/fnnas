# NanoPC-T4 设备配置

## 设备信息

- **型号**：FriendlyElec NanoPC-T4
- **制造商**：FriendlyARM (友善之臂)
- **SOC**：RK3399
- **配置 ID**：r429

## 硬件规格

- **CPU**：
  - 大核：Cortex-A72 双核 @ 2.2GHz
  - 小核：Cortex-A53 四核 @ 1.8GHz
- **GPU**：Mali-T860 MP4 @ 800MHz
- **内存**：4GB LPDDR3
- **存储**：16GB eMMC + TF 卡槽 + M.2 SSD 接口
- **网络**：Gigabit Ethernet
- **接口**：
  - USB 3.0 x 2
  - USB 2.0 x 2
  - HDMI 2.0
  - DisplayPort 1.2
  - M.2 PCIe (支持 NVMe SSD)
  - GPIO 40-pin

## 文件说明

### 设备树文件（DTB）
- **位置**：`make-fnnas/fnnas-files/platform-files/rockchip/bootfs/dtb/rockchip/`
- **文件名**：`rk3399-nanopc-t4.dtb`
- **特点**：已包含优化的超频配置（大核 2.2GHz，小核 1.8GHz，GPU 800MHz）

### 设备配置
- **位置**：`make-fnnas/fnnas-files/different-files/nanopc-t4/`
- **配置文件**：`rootfs/etc/fnnas-board-release.conf`

### 数据库条目
- **文件**：`make-fnnas/fnnas-files/common-files/etc/model_database.conf`
- **行号**：317
- **板型标识**：`nanopc-t4`

## 性能特点

### CPU 频率配置
- **小核 (Cortex-A53)**：
  - 408MHz ~ 1800MHz
  - 最高频率 1800MHz @ 1.275V（优化低压）

- **大核 (Cortex-A72)**：
  - 408MHz ~ 2208MHz
  - 最高频率 2208MHz @ 1.325V（优化低压）

### GPU 频率配置
- **Mali-T860 MP4**：
  - 200MHz ~ 800MHz
  - 最高频率 800MHz @ 1.100V

### 散热建议
- 设备已采用降压超频配置，发热控制良好
- 建议安装散热片或风扇以保持最佳性能
- 长时间高负载运行建议主动散热

## 构建命令

### 本地构建

```bash
# 准备基础镜像（放入 fnnas-arm64/ 目录）
# 示例：fnnas-arm64/fnos_arm_rockchip_330.img.xz

# 为 NanoPC-T4 构建（使用 6.1.y 内核）
sudo ./renas -b nanopc-t4 -k 6.1.y

# 使用特定内核版本
sudo ./renas -b nanopc-t4 -k 6.1.75

# 输出文件位置
ls -lh fnnas/out/
```

### GitHub Actions 构建

1. 进入仓库 Actions 页面
2. 选择 "Build FnNAS Image" 工作流
3. 点击 "Run workflow"
4. 配置参数：
   - `fnnas_base_version`: `rockchip_330`
   - `fnnas_board`: `nanopc-t4`
   - `fnnas_kernel`: `6.1.y`
   - `auto_kernel`: `true`
5. 点击 "Run workflow" 开始构建

## 安装和使用

### 1. 写入镜像

使用 Rufus（Windows）或 balenaEtcher（跨平台）将构建的镜像写入 TF 卡或 USB 设备。

### 2. 启动系统

1. 将 TF 卡插入 NanoPC-T4
2. 接通电源启动
3. 通过路由器查找设备 IP 地址
4. 浏览器访问：`http://设备IP:5666`
5. 创建账户并登录

### 3. 安装到 eMMC

SSH 连接到系统后：

```bash
# 安装到 eMMC
fnnas-install

# 根据提示选择安装选项
```

### 4. M.2 SSD 支持

NanoPC-T4 支持 M.2 NVMe SSD：

```bash
# 查看 NVMe 设备
lsblk

# 格式化并挂载（示例）
mkfs.ext4 /dev/nvme0n1p1
mkdir -p /mnt/nvme
mount /dev/nvme0n1p1 /mnt/nvme

# 添加到 fstab 自动挂载
echo "/dev/nvme0n1p1 /mnt/nvme ext4 defaults 0 0" >> /etc/fstab
```

### 5. 内核更新

```bash
# 更新到最新 6.1.y 系列内核
fnnas-update -k 6.1.y

# 更新到特定版本
fnnas-update -k 6.1.75

# SOS 恢复（如果更新后无法启动）
fnnas-update -s
```

## 技术细节

### 内核兼容性
- **KERNEL_TAGS**：`stable/6.1.y`
- 推荐使用 6.1.y 系列内核，与 RK3399 优化匹配

### 启动配置
- **BOOT_CONF**：`armbianEnv.txt`
- 使用 Armbian 风格的环境配置文件

### Bootloader
- **TRUST_IMG**：trust.bin
- **MAINLINE_UBOOT**：uboot.img
- **BOOTLOADER_IMG**：idbloader.bin

## 应用场景

NanoPC-T4 适合以下场景：

1. **家庭 NAS 服务器**
   - 强大的 CPU 性能支持多任务
   - M.2 SSD 支持高速存储扩展
   - Gigabit 网络保证传输速度

2. **媒体服务器**
   - 硬件视频解码
   - 4K@60fps 输出能力
   - 充足的内存支持转码

3. **开发平台**
   - 完整的 GPIO 接口
   - 丰富的扩展能力
   - 良好的散热设计

4. **轻量级服务器**
   - Docker 容器运行
   - 虚拟化支持
   - 低功耗设计

## 注意事项

1. **电源要求**：建议使用 5V/3A 或更高功率的电源适配器
2. **散热**：高负载下建议使用主动散热（风扇）
3. **M.2 兼容性**：支持 M.2 2280 NVMe SSD
4. **启动顺序**：TF 卡优先级高于 eMMC
5. **GPIO 电压**：GPIO 为 3.3V 电平，注意电平匹配

## 对比其他 RK3399 设备

| 设备 | CPU 频率 | 内存 | 存储 | M.2 SSD | 价格定位 |
|------|---------|------|------|---------|---------|
| NanoPC-T4 | 2.2/1.8GHz | 4GB | 16GB + TF + M.2 | ✅ | 中高端 |
| Fine3399 | 2.2/1.8GHz | 4GB | 最高 128GB | ❌ | 中端 |
| Rock Pi 4 | 2.0/1.4GHz | 1-4GB | TF + M.2 | ✅ | 中端 |
| Firefly RK3399 | 1.8GHz | 2-4GB | 16-32GB | ✅ | 开发板 |

NanoPC-T4 的优势在于：
- ✅ 最高的 CPU 频率（2.2GHz 大核）
- ✅ 原生 M.2 NVMe 支持
- ✅ 丰富的接口（双 HDMI + DP）
- ✅ 良好的社区支持

## 贡献者

- **isapce** - 添加 NanoPC-T4 FnNAS 支持

## 相关链接

- [FriendlyARM 官方网站](https://www.friendlyarm.com/)
- [NanoPC-T4 产品页](https://www.friendlyarm.com/index.php?route=product/product&product_id=225)
- [FnNAS 官方网站](https://fnnas.com/)
- [项目主页](https://github.com/ophub/fnnas)
- [添加新设备指南](../../../docs/添加新设备指南.md)
