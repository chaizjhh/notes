## 单元测试基础类

```java
import com.sankuai.mall.wms.web.ApplicationLoader;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = ApplicationLoader.class)
public class BaseUnit {

}
```

## thirft测试

```java
import com.sankuai.mall.wms.tservice.common.WmsTException;
import com.sankuai.mall.wms.tservice.lot.LogicLotTService;
import com.sankuai.mall.wms.tservice.lot.SkuLotAttrVTO;
import com.sankuai.mall.wms.tservice.lot.SkuLotStockPriceVo;
import org.apache.commons.collections.CollectionUtils;
import org.apache.thrift.TException;
import org.junit.Assert;
import org.junit.Test;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * @author lzh
 * @date 22.3.21 5:04 下午
 */
public class LogicServiceTest extends BaseUnit {

    @Resource
    private LogicLotTService.Iface logicTService;

    @Test
    public void testGetSkuLotAttrByLot() throws WmsTException, TException {
        long ownerId = 1L;
        long storeId = 10001L;
        int skuId = 3808;
        String lot = "SH201707120003-2017/07/12";

        List<SkuLotAttrVTO> lotAttrVTOList = logicTService.getSkuLotAttrByLot(ownerId, storeId, skuId, lot);

        Assert.assertEquals(1, CollectionUtils.size(lotAttrVTOList));
    }

    @Test
    public void testGetRecentPriceBySkuIds() throws WmsTException, TException {
        long poiId = 1L;
        long storeId = 10001L;
        long skuId = 3808L;
        List<Long> skuIdList = Arrays.asList(skuId);

        Map<Long, Long> recentPriceBySkuIds = logicTService.getRecentPriceBySkuIds(poiId, storeId, skuIdList);

        Assert.assertEquals(1, CollectionUtils.size(recentPriceBySkuIds.keySet()));
        Assert.assertTrue(recentPriceBySkuIds.keySet().contains(3808L));
        Assert.assertEquals(100L, recentPriceBySkuIds.get(skuId).longValue());
    }

    @Test
    public void  testGetRecentPriceAndStockBySkuIds() throws WmsTException, TException {
        long poiId = 1L;
        long storeId = 10001L;
        List<Long> skuIdList = Arrays.asList(3808L);

        Map<Long, Map<String, SkuLotStockPriceVo>> skuStockMap = logicTService.getRecentPriceAndStockBySkuIds(poiId, storeId, skuIdList);

        Assert.assertEquals(1, CollectionUtils.size(skuStockMap.keySet()));
    }
}
```

## RPC测试

```java
import com.sankuai.mall.wms.BaseUnit;
import com.sankuai.mall.wms.bean.sku.SkuBaseInfo;
import com.sankuai.mall.wms.tservice.common.WmsTException;
import org.apache.commons.collections.CollectionUtils;
import org.assertj.core.util.Lists;
import org.junit.Assert;
import org.junit.Test;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author wufan
 * @date 2021/9/16 23:59
 */
public class PoiSkuGatewayTest extends BaseUnit {

    @Resource
    private PoiSkuGateway poiSkuGateway;

    @Test
    public void testGetSkuInfoByPoiSkuIdListWhenNormal() throws WmsTException {
        long poiId = 1L;
        long skuId = 12L;
        ArrayList<Long> skuIdList = Lists.newArrayList(skuId);
        Map<Long, SkuBaseInfo> skuBaseInfoMap = poiSkuGateway.getSkuInfoByPoiSkuIdList(poiId, skuIdList);

        Assert.assertEquals(1, CollectionUtils.size(skuBaseInfoMap));
        Assert.assertTrue(skuBaseInfoMap.keySet().contains(skuId));

        SkuBaseInfo skuBaseInfo = skuBaseInfoMap.get(skuId);
        Assert.assertNotNull(skuBaseInfo);
        Assert.assertEquals(skuId, skuBaseInfo.getSkuId().longValue());
    }

    @Test
    public void testGetSkuInfoByPoiSkuIdListWhenNoSku() throws WmsTException {
        long poiId = 1L;
        long skuId = -12L;
        List<Long> skuIdList = Lists.newArrayList(skuId);

        Map<Long, SkuBaseInfo> skuBaseInfoMap = poiSkuGateway.getSkuInfoByPoiSkuIdList(poiId, skuIdList);

        Assert.assertEquals(0, CollectionUtils.size(skuBaseInfoMap));
    }

}
```
