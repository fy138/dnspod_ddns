作者：http://www.yiyou.org/

# dnspod_ddns
DNSPOD API &amp; DDNS script
这是DNSPOD perl API与ddns.pl更新脚本

安装方法：
1、执行
git clone https://github.com/fy138/dnspod_ddns.git

2、cd dnspod_ddns

3、chmod +x *.pl

4、 执行 ./require.pl 安装缺少的perl 模块
新系统需要安装gcc，openssl-devel，make 

5、在 ddns.pl 里编辑你的帐号信息

my $domain      = 'yiyou.org';  #域名

my $sub_domain  = 'home';       #子域名

my $email       = ''; #dnspod 帐号

my $password    = ''; #dnspod 密码

到此，你可以执行./ddns.pl这个程序来试试是否更新成功IP地址了。
(往下看日志文件位置)

6、执行./daemond.pl 
（如果你用crontab 则不需要执行这个文件,直接把./ddns.pl 放入crontab 就可以了。）
使用./daemond.pl可以省去你配置crontab的麻烦。
它可以将ddns.pl这个脚本变成进程，每60秒执行一次检查，当你修改代码时，要注意先停止，再启动，命令看下面。

相关命令：
shell#./daemond.pl start

shell#./daemond.pl status

shell#./daemond.pl stop

shell#./daemond.pl restart



启动进程后，会在本地目录生成 log 和pid文件
log文件 /var/log/dnspod_ddns.log
pid文件 /var/run/dnspod_ddns.pid

7、把/path/to/daemond.pl加入/etc/rc.local 让它随系统启动
