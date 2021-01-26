#include <fcntl.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

typedef struct tag_MMAP_Node {
  unsigned int Start_P;
  unsigned int Start_V;
  unsigned int length;
  unsigned int refcount;
  struct tag_MMAP_Node *next;
} TMMAP_Node_t;

TMMAP_Node_t *pTMMAPNode = NULL;
#define PAGE_SIZE 0x1000
#define PAGE_SIZE_MASK 0xfffff000

static int fd = -1;
static const char dev[] = "/dev/mem";
jmp_buf *sigbus_jmp;

//************************************************************
void *memmap(unsigned long phy_addr, unsigned long size) {
  unsigned long phy_addr_in_page;
  unsigned long page_diff;
  unsigned long size_in_page;
  unsigned long value = 0;
  TMMAP_Node_t *pTmp;
  TMMAP_Node_t *pNew;
  void *addr = NULL;
  if (size == 0) {
    printf("memmap():size can't be zero!\n");
    return NULL;
  }
  /* проверить, было ли преобразовано пространство физической памяти */
  pTmp = pTMMAPNode;
  while (pTmp != NULL) {
    if ((phy_addr >= pTmp->Start_P) &&
        ((phy_addr + size) <= (pTmp->Start_P + pTmp->length))) {
      pTmp->refcount++; /* referrence count increase by 1  */
      return (void *)(pTmp->Start_V + phy_addr - pTmp->Start_P);
    }
    pTmp = pTmp->next;
  }
  /* not mmaped yet */
  if (fd < 0) {
    /* dev not opened yet, so open it */
    fd = open(dev, O_RDWR | O_SYNC);
    if (fd < 0) {
      printf("memmap():open %s error!\n", dev);
      return NULL;
    }
  }
  /* addr align in page_size(4K) */
  phy_addr_in_page = phy_addr & PAGE_SIZE_MASK;
  page_diff = phy_addr - phy_addr_in_page;
  /* size in page_size */
  size_in_page = ((size + page_diff - 1) & PAGE_SIZE_MASK) + PAGE_SIZE;
  addr = mmap((void *)0, size_in_page, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
              phy_addr_in_page);
  if (addr == MAP_FAILED) {
    printf("memmap():mmap @ 0x%lx error!\n", phy_addr_in_page);
    return NULL;
  }
  /* add this mmap to MMAP Node */
  pNew = (TMMAP_Node_t *)malloc(sizeof(TMMAP_Node_t));
  if (NULL == pNew) {
    printf("memmap():malloc new node failed!\n");
    return NULL;
  }
  pNew->Start_P = phy_addr_in_page;
  pNew->Start_V = (unsigned long)addr;
  pNew->length = size_in_page;
  pNew->refcount = 1;
  pNew->next = NULL;
  if (pTMMAPNode == NULL) {
    pTMMAPNode = pNew;
  } else {
    pTmp = pTMMAPNode;
    while (pTmp->next != NULL) {
      pTmp = pTmp->next;
    }
    pTmp->next = pNew;
  }
  return (void *)(addr + page_diff);
}

#define DEFAULT_MD_LEN 256
//************************************************************
unsigned long GetValueRegister(unsigned long adress) {
  void *pMem = NULL;
  unsigned long value = -1;
  jmp_buf sigbus_jmpbuf;
  sigbus_jmp = &sigbus_jmpbuf;
  if (sigsetjmp(sigbus_jmpbuf, 1) == 0) {
    pMem = memmap(adress, DEFAULT_MD_LEN);
    if (pMem == NULL) {
      printf("memmap failed!\n");
      return -1;
    }
    value = *(unsigned int *)pMem; //читаем региср
  }
  return value;
}

//************************************************************
int SetValueRegister(unsigned long adress, unsigned long value) {
  void *pMem = NULL;
  pMem = memmap(adress, DEFAULT_MD_LEN);
  if (pMem == NULL) {
    printf("memmap failed!\n");
    return -1;
  }
  *(unsigned int *)pMem = value; //пишем в регистр
  return 0;
}

//************************************************************
void print_bin(unsigned long data) {
  int i;
  unsigned long ulbit;
  for (i = 7; i >= 0; i--) {
    ulbit = data >> i;
    if (ulbit & 1)
      printf("1");
    else
      printf("0");
  }
}

//************************************************************
void get_gpio_adress(unsigned long *Chip_Id, unsigned long *GPIO_Groups,
                     unsigned long *GPIO_Base, unsigned long *GPIO_Offset) {
  switch (*Chip_Id) {
    //-------------------------------------------
    // Hi3516Av100	A7 @600 MHz
  case 0x3516A100:
    *GPIO_Groups = 17; //пропустить G15
    *GPIO_Base = 0x20140000;
    *GPIO_Offset = 0x10000;
    break;
    //-------------------------------------------
    // Hi3516Cv100	ARM926 @440 MHz
  case 0x3516C100:
    *GPIO_Groups = 12;
    *GPIO_Base = 0x20140000;
    *GPIO_Offset = 0x10000;
    break;
  //-------------------------------------------
  // Hi3516Cv200	ARM926 @540 MHz
  case 0x3516C200:
    *GPIO_Groups = 9;
    *GPIO_Base = 0x20140000;
    *GPIO_Offset = 0x10000;
    break;
  //-------------------------------------------
  // Hi3516Cv300	ARM926 @800
  case 0x3516C300:
    *GPIO_Groups = 9;
    *GPIO_Base = 0x12140000;
    *GPIO_Offset = 0x1000;
    break;
  //-------------------------------------------
  // Hi3516Dv100	A7 @600 MHz
  case 0x3516D100:
    *GPIO_Groups = 15;
    *GPIO_Base = 0x20140000;
    *GPIO_Offset = 0x10000;
    break;
  //-------------------------------------------
  // Hi3516Ev200	A7 @900MHz
  case 0x3516E200:
    *GPIO_Groups = 9;
    *GPIO_Base = 0x120B0000;
    *GPIO_Offset = 0x1000;
    break;
  //-------------------------------------------
  // Hi3516Ev300	A7 @900MHz
  case 0x3516E300:
    *GPIO_Groups = 10;
    *GPIO_Base = 0x120B0000;
    *GPIO_Offset = 0x1000;
    break;
  //-------------------------------------------
  // Hi3518Ev100	ARM926 @440 MHz
  case 0x35180100:
    *GPIO_Groups = 12;
    *GPIO_Base = 0x20140000;
    *GPIO_Offset = 0x10000;
    break;
  //-------------------------------------------
  // Hi3518Ev200	ARM926 @540 MHz
  case 0x3518E200:
    *GPIO_Groups = 9;
    *GPIO_Base = 0x20140000;
    *GPIO_Offset = 0x10000;
    break;
  //-------------------------------------------
  // Hi3518Ev201	ARM926 @540 MHz
  case 0x3518E201:
    *GPIO_Groups = 9;
    *GPIO_Base = 0x20140000;
    *GPIO_Offset = 0x10000;
    break;
  //-------------------------------------------
  default:
    *GPIO_Groups = 0;
    *GPIO_Base = 0;
    *GPIO_Offset = 0;
    break;
    //---------------------------------
  }
}
//************************************************************
int main() {
  unsigned long Chip_Id;
  unsigned long GPIO_Groups, GPIO_Base, GPIO_Offset;
  unsigned long address = 0;
  unsigned long direct = 0;
  unsigned long value = 0;
  unsigned long OldValue[20];
  int bit, old_bit, new_bit;
  int i, group, mask;
  //---------------------------------------------------------------
  Chip_Id = 0x3516E200;
  printf("========== Hisilicon GPIO Scaner (2020) Andrew_kmr - OpenIPC.org "
         "collective ==========\n");
  printf("Chip_Id: 0x%08lX\n", Chip_Id);
  printf("---------------------------------------------------------------------"
         "-----------------\n");
  get_gpio_adress(&Chip_Id, &GPIO_Groups, &GPIO_Base, &GPIO_Offset);
  if (GPIO_Base == 0) {
    printf("This CPU is not supported!\n");
    return 0;
  }
  for (group = 0; group < GPIO_Groups; group++) {
    address = GPIO_Base + (group * GPIO_Offset) + 0x3fc; //регистр данных портов
    value = GetValueRegister(address); //регистр данных портов
    OldValue[group] = value; //запоминаем в массив значение
    printf("Gr:%2d, Addr:0x%08lX, Data:0x%02lX = 0b", group, address, value);
    print_bin(value); //выводим бинарный вид
    address =
        GPIO_Base + (group * GPIO_Offset) + 0x400; //регистр направления портов
    direct = GetValueRegister(address);
    printf(", Addr:0x%08lX, Dir:0x%02lX = 0b", address, direct);
    print_bin(direct);
    printf("\n");
  }
  printf("While change value...\n");
  while (1) {
    for (group = 0; group < GPIO_Groups; group++) {
      address =
          GPIO_Base + (group * GPIO_Offset) + 0x3fc; //регистр данных портов
      value = GetValueRegister(address);
      if (OldValue[group] != value) //старый и новый байты не равны
      {
        printf("---------------------------------------------------------------"
               "-----------------------\n");
        printf("Gr:%d, Addr:0x%08lX, Data:0x%02lX = 0b", group, address,
               OldValue[group]);
        print_bin(OldValue[group]);
        printf(" --> 0x%02lX = 0b", value);
        print_bin(value);
        printf("\n");
        for (bit = 7; bit >= 0; bit--) //цикл побитного сравнения
        {
          old_bit = (OldValue[group] >> bit) & 1;
          new_bit = (value >> bit) & 1;
          if (old_bit != new_bit) {
            address = GPIO_Base + (group * GPIO_Offset) +
                      0x400; //регистр направления портов
            direct = GetValueRegister(address);
            direct = (direct >> bit) &
                     1; //получили бит направления порта 0-вход 1-выход
            address = GPIO_Base + (group * GPIO_Offset) + (1 << (bit + 2));
            if (direct == 1) {
              mask = value & 1 << bit;
              printf("Mask: \"himm 0x%08lX 0x%02X\", GPIO%d_%d, GPIO%d, "
                     "Dir:Output, Level:%d\n",
                     address, mask, group, bit, (group * 8) + bit, new_bit);
            } else {
              mask = value & 1 << bit;
              printf("Mask: \"himm 0x%08lX 0x%02X\", GPIO%d_%d, GPIO%d, "
                     "Dir:Input, Level:%d\n",
                     address, mask, group, bit, (group * 8) + bit, new_bit);
            }
          }
        }
        OldValue[group] = value; //запоминаем новое значение
      }
    }
    usleep(100000);
  }
  return 0;
}
