作者：http://www.yiyou.org/

# dnspod_ddns
DNSPOD API &amp; DDNS script
这是DNSPOD perl API与ddns.pl更新脚本

安装方法：
1、执行
git clone https://github.com/fy138/dnspod_ddns.git

2、cd dnspod_ddns

3、chmod +x require.pl

4、 执行 ./require.pl 安装缺少的perl 模块
新系统需要安装gcc，openssl-devel，make 

5、在 ddns.pl 里编辑你的帐号信息

my $domain      = 'yiyou.org';  #域名
my $sub_domain  = 'home';       #子域名
my $email       = ''; #dnspod 帐号
my $password    = ''; #dnspod 密码

到此，你可以执行这个程序来试试是否更新成功IP地址了。

6、chmod +x  daemond.pl 如果你用crontab 则不需要执行这个文件。
这个文件可以省去你配置crontab 的麻烦。它可以将这个脚本变成进程，每300秒执行一次检查，当你修改代码时，要注意先这个进程杀死，再重新执行。
