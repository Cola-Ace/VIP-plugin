# 使用说明
**在使用前请先配置名为 vip 的数据库，需导入sql文件**

指令：!vip 打开vip总菜单

# 插件说明

- vip.smx
  - 主插件
- vip_damageprint.smx
  - 显示自己攻击的敌人受到的伤害
- vip_disablecommand.smx
  - 禁用指令，仅VIP可使用
  - 需配置addons/sourcemod/configs/vip_command.cfg
- vip_disablesticker.smx
  - 玩家不是VIP时移除武器上所有的贴纸
  - 需要前置插件eItems，csgo_weaponstickers
- vip_flag.smx
  - 自动向管理员添加年VIP
- vip_levelicon.smx
  - 更改VIP的等级图标
- vip_onlyvip.smx
  - 仅VIP可进入服务器
- vip_profilelimiter.smx
  - 时长限制
  - VIP可无视时长限制
  - 需要配置Steam API Key
- vip_extrusion.smx
  - VIP可挤出不是VIP且不是管理员的玩家（可在cfg/sourcemod/vip_extrusion.cfg里配置最大玩家数）
- vip_giveflag.smx
  - VIP会获得对应的权限，退出服务器时会自动删除（管理员不受影响）

# API
- <kbd>forward void</kbd> VIP_OnKeyExchange
    - 说明：当玩家兑换VIP卡密成功时调用
    - <kbd>client</kbd> client index.
    - <kbd>key</kbd> vip key.
    - <kbd>days</kbd> key days.
- <kbd>forward void</kbd> VIP_OnClientPutInServer
    - 说明：当玩家进入服务器，且读取完用户VIP数据时调用
    - <kbd>client</kbd> client index.
    - <kbd>State</kbd> client vip state.
- <kbd>forward void</kbd> VIP_OnClientStateChanged
    - 说明：当玩家的VIP状态改变时调用
    - <kbd>client</kbd> client index.
    - <kbd>State</kbd> client vip state.
- <kbd>native void</kbd> VIP_Message
    - 说明：向指定玩家发送信息，会自动带上VIP前缀
    - <kbd>client</kbd> client index.
    - <kbd>text</kbd> Format message.
- <kbd>native void</kbd> VIP_MessageToAll
    - 说明：向所有玩家发送信息，会自动带上VIP前缀
    - <kbd>text</kbd> Format message.
- <kbd>native bool</kbd> VIP_IsVIP
    - 说明：判断玩家是否为VIP，是则返回true，不是则返回false
    - <kbd>client</kbd> client index.
- <kbd>native int</kbd> VIP_GetClientDays
    - 说明：返回玩家的VIP剩余天数，若玩家不是VIP或不是一个有效的玩家则返回-1
    - <kbd>client</kbd> client index.
- <kbd>native bool</kbd> VIP_SetClientDays
    - 说明：设置玩家的VIP剩余天数，若用户未拥有VIP则自动注册用户信息
    - <kbd>client</kbd> client index.
    - <kbd>days</kbd> vip days.
- <kbd>native bool</kbd> VIP_SetClientState
    - 说明：设置玩家的VIP状态
    - <kbd>client</kbd> client index.
    - <kbd>state</kbd> vip state.
- <kbd>native VIPState</kbd> VIP_GetClientState
    - 说明：获取玩家的VIP状态
    - <kbd>client</kbd> client index.
# 更新日志

- 2022-5-20 21:06
  - 增加新功能：VIP在进入游戏后可自动获得对应的权限
  - 修复VIP挤人功能无法正常使用的bug
- 2022-5-15 12:44
  - 增加新功能：VIP可挤人
- 2022-1-30 1:34
  - 增加新功能：在configs/vip_flags.cfg里配置，玩家会在兑换VIP成功后获得对应的权限组
- 2021-4-5 12:56
  - 修复Duplicate entry ' ' for key 'PRIMARY'的报错
- 2021-2-20 16:44
  - 修复进服提示显示错误的bug
  - 估计是六月份前最后一次更新（除重大BUG以外暂时停止更新）
- 2021-2-15 0:10
  - 本次更新有更改数据库的表，如需导入sql文件请先备份数据，数据丢失概不负责
  - 新增vip_logs插件，可记录操作日志（兑换卡密，玩家VIP状态改变）
  - 修复时长限制不生效的bug
  - 修复vip_onlyvip插件不生效的bug
  - 修复了如果玩家不是VIP则不会调用VIP_OnClientPutInServer的bug
  - 修复了VIP_OnClientPutInServer的VIPState不会出现VIPState_NoVIP的bug
  - 写给开发者：从这次更新后每次更新都会在.inc文件里写本次更新内容（更详细）和TODO
- 2021-2-6 22:30
  - 新增vip_flag插件，会自动令管理员拥有年VIP
  - 新增API
  - 新增年VIP判断
  - 修改了数据库中vipUsers的结构
  - 修复了BUG
- 2021-1-30 21:52
  - 修改自动更新地址
- 2021-1-30 20:34
  - 修改了VIP时长限制，可自定义限制时长，踢出信息
  - 新增仅VIP可进入的插件
  - 修复自动更新bug
- 2021-1-23 13:20
  - 修复了颜色代码不生效的bug
- 2021-1-22 21:00
  - 版本变更为1.6.1
  - 新增自动更新（测试），需要安装updater插件
- 2021-1-22 17:00
  - 跳过1.5版本，来到1.6版本
  - VIP功能模块化
  - 优化了VIP系统
  - 新增VIP时长限制（目前锁定200小时，后续会出自定义，可自己更改源码编译，需要system2扩展）
  - 修复了一些bug
  - 新增api
- 2020-12-13 0:35
  - 修复了聊天前缀以及聊天中所有颜色不保存的bug
  - 修复了数据库不保存聊天中所有颜色的bug *原显示乱码*
- 2020-12-11 23:10
  - 更新了断开连接时的提示
  - 更新了自定义前缀
  - 更新了伤害提示
  - 新增api
  - 修复了玩家不是vip但仍然会显示进服提示的bug
# 即将完成

- 计划移除chat-processor插件