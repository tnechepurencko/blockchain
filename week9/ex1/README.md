![img.png](img.png)

![img_1.png](img_1.png)

Cannot withdraw because ```now < lockTime[msg.sender]```

Mitigation strategy: 

    ```require(_secondsToIncrease >= _secondsToIncrease - lockTime[msg.sender], "Lock time will be overflowed");```