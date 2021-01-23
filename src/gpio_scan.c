#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

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
  printf("Chip_Id: 0x%08X\n", Chip_Id);
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
