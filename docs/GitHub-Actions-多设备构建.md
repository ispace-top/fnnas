# GitHub Actions 多设备构建指南

## 快速开始

### 构建 NanoPC-T4 和 Fine3399-Plus

1. 进入仓库 **Actions** 页面
2. 选择 **"Build FnNAS Image"** 工作流
3. 点击 **"Run workflow"** 按钮
4. 配置参数：

```
fnnas_base_version:  rockchip_330
fnnas_board:         nanopc-t4_fine3399-plus  ← 选择此组合选项
fnnas_kernel:        6.1.y
auto_kernel:         true
kernel_repo:         ophub/fnnas
builder_name:        您的名字
```

5. 点击 **"Run workflow"** 开始构建

## 构建选项说明

### 单设备构建

| 选项 | 描述 |
|------|------|
| `nanopc-t4` | 仅构建 NanoPC-T4 |
| `fine3399-plus` | 仅构建 Fine3399-Plus |
| `fine3399` | 仅构建 Fine3399 标准版 |

### 多设备组合构建

| 选项 | 包含设备 |
|------|---------|
| `nanopc-t4_fine3399-plus` | NanoPC-T4 + Fine3399-Plus |
| `all` | 所有设备（400+ 机型） |
| `first50` | 前 50 个设备 |

### 自定义组合

您可以使用下划线 `_` 组合任意设备：

```bash
# 三个设备
nanopc-t4_fine3399_fine3399-plus

# 其他 RK3399 设备组合
nanopc-t4_firefly-rk3399_king3399

# 本地测试命令
sudo ./renas -b nanopc-t4_fine3399-plus -k 6.1.y
```

## 构建结果

构建完成后，在 **Releases** 页面将看到：

```
📦 fnnas_NanoPC-T4_6.1.y_YYYYMMDD.img.gz
📦 fnnas_Fine3399-Plus_6.1.y_YYYYMMDD.img.gz
```

每个设备独立打包，可单独下载使用。

## 预估时间

| 构建类型 | 预估时间 |
|---------|---------|
| 单个设备 | 15-20 分钟 |
| 两个设备 | 30-40 分钟 |
| all（全部设备） | 8-12 小时 |

## 添加更多组合

编辑 `.github/workflows/build-fnnas-image.yml`：

```yaml
fnnas_board:
  options:
    - all
    - nanopc-t4_fine3399-plus  # 已添加
    - 您的自定义组合           # 添加新的
```

## 常见问题

**Q: 能否同时构建不同平台的设备？**

不建议。不同平台需要不同的基础镜像：
- Rockchip 设备：使用 `rockchip_330`
- Amlogic 设备：使用 `amlogic_338`
- Allwinner 设备：使用 `allwinner_335`

建议分别构建不同平台的设备。

**Q: 构建失败怎么办？**

1. 检查 Actions 日志
2. 确认内核版本存在
3. 验证 DTB 文件完整
4. 重新触发构建

**Q: 如何加速构建？**

1. 减少设备数量（单独构建）
2. 使用缓存的内核（auto_kernel: false）
3. 选择较新的基础镜像版本

## 本地测试

在提交到 GitHub 前，建议本地测试：

```bash
# 准备基础镜像
mkdir -p fnnas-arm64
# 下载 Rockchip 镜像到 fnnas-arm64/

# 构建两个设备
sudo ./renas -b nanopc-t4_fine3399-plus -k 6.1.y

# 查看结果
ls -lh fnnas/out/
```

## 相关链接

- [FnNAS 官方](https://fnnas.com/)
- [项目主页](https://github.com/ophub/fnnas)
- [添加新设备指南](../../docs/添加新设备指南.md)
- [NanoPC-T4 说明](../../make-fnnas/fnnas-files/different-files/nanopc-t4/README.md)
- [Fine3399-Plus 说明](../../make-fnnas/fnnas-files/different-files/fine3399-plus/README.md)
