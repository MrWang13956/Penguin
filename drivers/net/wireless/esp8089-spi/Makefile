# SPDX-License-Identifier: GPL-2.0 

#EXTRA_CFLAGS += -DDEBUG -DSIP_DEBUG -DDEBUG_FS
EXTRA_CFLAGS += -DFAST_TX_STATUS -DRX_SENDUP_SYNC
EXTRA_CFLAGS += -DKERNEL_IV_WAR -DSIF_DSR_WAR 
EXTRA_CFLAGS += -DHAS_INIT_DATA
EXTRA_CFLAGS += -DP2P_CONCURRENT 
EXTRA_CFLAGS += -DHAS_FW
EXTRA_CFLAGS += -DESP_ACK_INTERRUPT
EXTRA_CFLAGS += -DESP_USE_SPI
EXTRA_CFLAGS += -DREGISTER_SPI_BOARD_INFO
EXTRA_CFLAGS += -w

ifdef ANDROID
EXTRA_CFLAGS += -DANDROID
endif

ifdef P2P_CONCURRENT
EXTRA_CFLAGS += -DP2P_CONCURRENT
endif

ifdef TEST_MODE
EXTRA_CFLAGS += -DTEST_MODE
endif

obj-$(CONFIG_WLAN_ESP8089_SPI)	+= esp8089_spi.o
esp8089_spi-y += esp_debug.o sdio_sif_esp.o spi_sif_esp.o esp_io.o \
    esp_file.o esp_main.o esp_sip.o esp_ext.o esp_ctrl.o \
    esp_mac80211.o esp_debug.o esp_utils.o esp_pm.o testmode.o
