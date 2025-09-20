## 被测试对象

```java
@Service
public class StockChangeSyncService {

  @Resource
  private LotStockEventProducer lotStockEventProducer;
  
  private void sendStockChangeEvent(InventoryBase inventoryBase, List<StockOptResultBiz> inventoryList) {
        if (CollectionUtils.isEmpty(inventoryList)) {
            return;
        }

        try {
            String appKey = inventoryBase.getAppKey();
            String requestId = inventoryBase.getRequestId();
            Integer businessId = Business.getBusinessId(inventoryBase);
            if (StringUtils.isBlank(appKey)) {
                String billCode = inventoryBase.getBillCode();
                String originBillCode = inventoryBase.getOriginBillCode();
                String baseJson = JsonUtil.toString(inventoryBase);
                logger.info("appKey is empty, businessId:{}, billCode:{}, originBillCode:{}, base:{}",
                        businessId, billCode, originBillCode, baseJson);
            }

            if (StringUtils.isBlank(appKey) || StringUtils.isBlank(requestId)) {
                String billCode = inventoryBase.getBillCode();
                String originBillCode = inventoryBase.getOriginBillCode();
                String baseJson = JsonUtil.toString(inventoryBase);
                logger.info("appKey or requestId is empty, businessId:{}, billCode:{}, originBillCode:{}, base:{}",
                        businessId, billCode, originBillCode, baseJson);
            }

            LotStockEvent lotStockEvent = new LotStockEvent(inventoryBase, inventoryList);
            String mqGroup = lotStockEvent.mqGroup();
            int logicStockAttrQuerySize = LOGIC_STOCK_ATTR_QUERY_SIZE;

            if (BooleanUtils.isFalse(lotStockEvent.splitEnable(logicStockAttrQuerySize))) {
                lotStockEventProducer.sendWithPartKey(JsonUtil.toString(lotStockEvent), mqGroup);
            } else {
                List<LotStockEvent> lotStockEventList = lotStockEvent.split(logicStockAttrQuerySize);
                for (LotStockEvent tmpLotStockEvent : lotStockEventList) {
                    lotStockEventProducer.sendWithPartKey(JsonUtil.toString(tmpLotStockEvent), mqGroup);
                }
            }
        } catch (Exception e) {
            logger.error("send stock change event error.", e);
        }
    }
  
}
```

## 单元测试

```java
import com.sankuai.mall.wms.bean.enums.Business;
import com.sankuai.mall.wms.bean.enums.Classify;
import com.sankuai.mall.wms.bean.inv.InventoryBase;
import com.sankuai.mall.wms.bean.inv.StockOptResultBiz;
import com.sankuai.mall.wms.mq.producer.LotStockEventProducer;
import org.assertj.core.util.Lists;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.test.util.ReflectionTestUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static com.sankuai.mall.wms.constants.AllMccVarsConstants.LOGIC_STOCK_ATTR_QUERY_SIZE;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class StockChangeSyncServiceTests {

    @InjectMocks
    private StockChangeSyncService stockChangeSyncService;

    @Mock
    private LotStockEventProducer lotStockEventProducer;

    /**
     * 测试场景：搬仓工具调拨出库,验证mq消息分组是目标门店id
     */
    @Test
    public void testMqGroupWhenTransferPoiStockOut() {
        InventoryBase base = genForTransferPoiStock(Business.TRANSFER_OUT);
        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("16"));
    }

    /**
     * 测试场景：非搬仓工具调拨出库的业务类型,验证mq消息分组是当前门店id
     */
    @Test
    public void testMqGroupWhenNotTransferPoiStockOut() {
        InventoryBase base = genForTransferPoiStock(Business.TRANSFER_IN);

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型既不是越库出库也不是调拨出库,验证消息分组为当前门店id
     */
    @Test
    public void testMqGroupWhenNoneTransferOutAndTempOut() {
        InventoryBase base = genForTransferPoiStock(Business.TRANSFER_IN);

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型是FDC调拨出库,验证消息分组为当前门店id
     */
    @Test
    public void testMqGroupWhenFDCTransferOut() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_OUT, "FH2021110305596116");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型是RDC调拨出库并且业务单号缺少目标门店,验证消息分组为当前门店id
     */
    @Test
    public void testMqGroupWhenRDCInvalidTransferOutWithoutTargetOwnerId() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_OUT, "000158ZCD2021110373265343");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型是RDC调拨出库,业务单号包含目标门店但是包含其他非法参数,验证消息分组为当前门店id
     */
    @Test
    public void testMqGroupWhenRDCInvalidTransferOutWithTargetOwnerIdAndOtherParameter() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_OUT, "000158ZCD2021110373265343-128-other");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型是RDC调拨出库并且业务单号缺少目标门店,验证消息分组为当前门店id
     */
    @Test
    public void testMqGroupWhenRDCInvalidTransferOutWithTargetOwnerIdAndEndWithEmpty() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_OUT, "000158ZCD2021110373265343-");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型是RDC调拨出库,业务单号中目标门店号为英文字母,验证消息分组为当前门店id
     */
    @Test
    public void testMqGroupWhenRDCTransferOutWithInvalidTargetOwnerId() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_OUT, "000158ZCD2021110373265343-xxx");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型是RDC调拨出库,业务单号中目标门店号不是十进制数字,验证消息分组为当前门店id
     */
    @Test
    public void testMqGroupWhenRDCTransferOutWithTargetOwnerIdNotDecimalSystem() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_OUT, "000158ZCD2021110373265343-0xFF");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：业务类型是RDC调拨出库,业务单号是规范的单据号,验证消息分组为目标门店id
     */
    @Test
    public void testMqGroupWhenRDCValidTransferOut() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_OUT, "000158ZCD2021110373265343-128");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("128"));
    }

    /**
     * 测试场景：业务类型是RDC越库出库,业务单号是规范的单据号,验证消息分组为目标门店id
     */
    @Test
    public void testMqGroupWhenRDCValidTempOut() {
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TEMP_OUT, "000158ZCD2021110373265343-128");

        List<StockOptResultBiz> bizList = getSpecialUnlock(base.getOwnerId(), 100);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("128"));
    }

    private InventoryBase genForTransferPoiStock(Business business) {
        InventoryBase base = new InventoryBase();

        base.setOwnerId(12L);
        base.setStoreId(12L);
        base.setAppKey("wms");
        base.setTargetOwnerId(16L);
        base.setOptTime(System.currentTimeMillis());
        base.setBusiness(business);

        return base;
    }

    private InventoryBase genLotStockEventForMqGroupTest(Business business, String billCode) {
        InventoryBase base = new InventoryBase();

        base.setOwnerId(12L);
        base.setStoreId(12L);
        base.setAppKey("wos");
        base.setBillCode(billCode);
        base.setOptTime(System.currentTimeMillis());
        base.setBusiness(business);

        return base;
    }

    /**
     * 测试场景：非移库业务类型,不进行消息拆分
     */
    @Test
    public void testSplitEnableWhenNotTransferAreaInWarehouse() {
        int transferOutLotStockSize = 10;
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TEMP_OUT, "000158ZCD2021110373265343-128");
        List<StockOptResultBiz> bizList = getNormalDetailListForSplitEnable(base.getOwnerId(), transferOutLotStockSize);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("128"));
    }

    /**
     * 测试场景：移库业务类型,消息明细为空不进行消息拆分
     */
    @Test
    public void testSplitEnableWhenTransferAreaInWarehouseWithEmptyDetailList() {
        int transferOutLotStockSize = 0;
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_AREA_IN_WAREHOUSE, "YK000000001");
        List<StockOptResultBiz> bizList = getNormalDetailListForSplitEnable(base.getOwnerId(), transferOutLotStockSize);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer, never()).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：移库业务类型,消息明细列表小于阈值不进行消息拆分
     */
    @Test
    public void testSplitEnableWhenTransferAreaInWarehouseWithLessThanLimitDetailList() {
        int transferOutLotStockSize = 10;
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_AREA_IN_WAREHOUSE, "YK000000001");
        List<StockOptResultBiz> bizList = getNormalDetailListForSplitEnable(base.getOwnerId(), transferOutLotStockSize);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：移库业务类型,消息明细列表等于阈值不进行消息拆分
     */
    @Test
    public void testSplitEnableWhenTransferAreaInWarehouseWithEqualLimitDetailList() {
        int transferOutLotStockSize = LOGIC_STOCK_ATTR_QUERY_SIZE / 2;
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_AREA_IN_WAREHOUSE, "YK000000001");
        List<StockOptResultBiz> bizList = getNormalDetailListForSplitEnable(base.getOwnerId(), transferOutLotStockSize);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：移库业务类型,消息明细列表大于阈值进行消息拆分
     */
    @Test
    public void testSplitEnableWhenTransferAreaInWarehouseWithMoreThanLimitDetailList() {
        int transferOutLotStockSize = LOGIC_STOCK_ATTR_QUERY_SIZE / 2 + 2;
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_AREA_IN_WAREHOUSE, "YK000000001");
        List<StockOptResultBiz> bizList = getNormalDetailListForSplitEnable(base.getOwnerId(), transferOutLotStockSize);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer, times(2)).sendWithPartKey(anyString(), eq("12"));
    }

    /**
     * 测试场景：解锁移库业务类型,消息明细列表大于阈值不进行消息拆分
     */
    @Test
    public void testSplitEnableWhenUnlockTransferWithMoreThanLimitDetailList() {
        int transferOutLotStockSize = LOGIC_STOCK_ATTR_QUERY_SIZE / 2 + 2;
        InventoryBase base = genLotStockEventForMqGroupTest(Business.TRANSFER_AREA_IN_WAREHOUSE, "YK000000001");
        List<StockOptResultBiz> bizList = getNormalDetailListForSplitEnable(base.getOwnerId(), transferOutLotStockSize);

        ReflectionTestUtils.invokeMethod(stockChangeSyncService, "sendStockChangeEvent", base, bizList);
        verify(lotStockEventProducer, times(2)).sendWithPartKey(anyString(), eq("12"));
    }

    private List<StockOptResultBiz> getNormalDetailListForSplitEnable(long ownerId, int transferOutLotStockSize) {
        if (transferOutLotStockSize == 0) {
            return Lists.newArrayList();
        }

        List<StockOptResultBiz> detailList = new ArrayList<>();
        for (int i = 0; i < transferOutLotStockSize; i++) {
            Random random = new Random();
            long skuId = Long.valueOf(random.nextInt(5000)) + 5000 * i;
            long lotId = Long.valueOf(random.nextInt(5000)) + 5000 * i;
            long outShelfId = Long.valueOf(random.nextInt(5000)) + 5000 * i;
            long inShelfId = outShelfId + 1L;

            StockOptResultBiz outDetail = getLotStockOpDetail(ownerId, skuId, lotId);
            outDetail.setClassify(Classify.OUT);
            outDetail.setShelfId(outShelfId);

            StockOptResultBiz inDetail = getLotStockOpDetail(ownerId, skuId, lotId);
            inDetail.setClassify(Classify.IN);
            inDetail.setShelfId(inShelfId);

            detailList.add(outDetail);
            detailList.add(inDetail);
        }

        return detailList;
    }

    private List<StockOptResultBiz> getSpecialUnlock(long ownerId, int transferOutLotStockSize) {
        if (transferOutLotStockSize == 0) {
            return Lists.newArrayList();
        }

        List<StockOptResultBiz> detailList = new ArrayList<>();
        Random random = new Random();
        long skuId = 1L;
        long lotId = 1L;
        long outShelfId = Long.valueOf(random.nextInt(5000));

        StockOptResultBiz unlockDetail = getLotStockOpDetail(ownerId, skuId, lotId);
        unlockDetail.setClassify(Classify.UNLOCK);
        unlockDetail.setShelfId(outShelfId);

        StockOptResultBiz outDetail = getLotStockOpDetail(ownerId, skuId, lotId);
        outDetail.setClassify(Classify.OUT);
        outDetail.setShelfId(outShelfId);

        StockOptResultBiz outDetail2 = getLotStockOpDetail(ownerId, skuId, lotId);
        outDetail2.setClassify(Classify.OUT);
        outDetail2.setShelfId(outShelfId);

        detailList.add(unlockDetail);
        detailList.add(outDetail);
        detailList.add(outDetail2);

        for (int i = 0; i < transferOutLotStockSize - 1; i++) {
            Random tmpRandom = new Random();
            long tmpSkuId = Long.valueOf(tmpRandom.nextInt(5000)) + 5000 * i;
            long tmpLotId = Long.valueOf(tmpRandom.nextInt(5000)) + 5000 * i;
            long tmpOutShelfId = Long.valueOf(tmpRandom.nextInt(5000)) + 5000 * i;

            StockOptResultBiz tmpUnlockDetail = getLotStockOpDetail(ownerId, tmpSkuId, tmpLotId);
            tmpUnlockDetail.setClassify(Classify.UNLOCK);
            tmpUnlockDetail.setShelfId(tmpOutShelfId);

            StockOptResultBiz tmpOutDetail = getLotStockOpDetail(ownerId, tmpSkuId, tmpLotId);
            tmpOutDetail.setClassify(Classify.OUT);
            tmpOutDetail.setShelfId(tmpOutShelfId);

            detailList.add(tmpUnlockDetail);
            detailList.add(tmpOutDetail);
        }

        return detailList;
    }

    private StockOptResultBiz getLotStockOpDetail(long ownerId, long skuId, long lotId) {
        StockOptResultBiz detail = new StockOptResultBiz();

        detail.setOwnerId(ownerId);
        detail.setSkuId(skuId);
        detail.setAttrId(lotId);
        detail.setDepartmentId(1L);
        detail.setOptQuantity(BigDecimal.ZERO);
        detail.setPreaddQuantity(BigDecimal.ZERO);
        detail.setRemainQuantity(BigDecimal.ZERO);
        detail.setOptAfterQuantity(BigDecimal.ZERO);
        detail.setPrimaryId(1L);
        detail.setProductionDate(System.currentTimeMillis());

        return detail;
    }
}
```
