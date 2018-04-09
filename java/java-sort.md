# 排序
## 冒泡排序
是一种稳定排序算法。平均时间复杂度为O(N^2)，最好情况O(N)。当数据越接近正序时，冒泡排序性能越好

    private static void bubbleSort(Integer[] arr) {
        int temp = 0, index = arr.length -1; 

        for (int i = 0; i < index; i++) {
            // 从后向前依次的比较相邻两个数的大小，遍历一次后，把数组中第i小的数放在第i个位置上
            for (int j = index; j > i; j--) {
                // 比较相邻的元素，如果前面的数大于后面的数，则交换
                if (arr[j - 1] > arr[j]) {
                    temp = arr[j - 1];
                    arr[j - 1] = arr[j];
                    arr[j] = temp;
                }
            }
            System.out.println("i = "+ i + Arrays.asList(arr));
        }

        System.out.println("arr = " + Arrays.asList(arr));
    }

    //冒泡排序优化
    private static void bubbleSort2(Integer[] arr) {
        int temp = 0, index = arr.length -1;
        boolean needChange;

        for (int i = 0; i < index; i++) {
            needChange = false;
            // 从后向前依次的比较相邻两个数的大小，遍历一次后，把数组中第i小的数放在第i个位置上
            for (int j = index; j > i; j--) {
                // 比较相邻的元素，如果前面的数大于后面的数，则交换
                if (arr[j - 1] > arr[j]) {
                    temp = arr[j - 1];
                    arr[j - 1] = arr[j];
                    arr[j] = temp;
                    needChange = true;
                }
            }

            // 如果标志为false，说明本轮遍历没有交换，已经是有序数列，可以结束排序
            if (needChange == false) {
                break;
            }
        }

        System.out.println("arr = " + Arrays.asList(arr));
    }