
XSCTH_WS = "${TOPDIR}/../components/plnx_workspace/pmufw"
EXTERNALXSCTSRC = "${PETALINUX}/tools/hsm/data/embeddedsw"
EXTERNALXSCTSRCHASH = "build"
inherit externalxsctsrc
EXTERNALXSCTSRC_BUILD = "${TOPDIR}/../components/plnx_workspace/pmufw"
export _JAVA_OPTIONS
_JAVA_OPTIONS = "-Duser.home=${TMPDIR}/xsctenv"
YAML_SERIAL_CONSOLE_STDOUT = "psu_uart_0"
YAML_SERIAL_CONSOLE_STDIN = "psu_uart_0"
