#include <configs/platform-auto.h>

/* Extra U-Boot Env settings */
#define CONFIG_EXTRA_ENV_SETTINGS \
	SERIAL_MULTI \ 
	CONSOLE_ARG \ 
	PSSERIAL0 \ 
	"sd_dev=0\0" \
	"sd_part=1\0" \
	"boot_env=uEnv.txt\0" \
	"boot_env_addr=0x13800000\0" \
	"loadbootenv=fatload mmc $sd_dev:$sd_part ${boot_env_addr} ${boot_env}\0" \ 
	"importbootenv=env import -t ${boot_env_addr} $filesize\0" \ 
	"bootcmd=run loadbootenv && run importbootenv && run uenv_boot\0" \
""

