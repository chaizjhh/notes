# Http
**参考博客：**[Http中的Content-Type详解_非著名程序员:张张的博客-CSDN博客](https://blog.csdn.net/m0_49508485/article/details/127056301)

## header
### Content-Type
在HTTP协议消息头中，使用Content-Type来表示请求和响应中的媒体类型信息。它用来告诉服务端如何处理请求的数据，以及告诉客户端如何解析响应的数据。Content-Type的格式：type/subtype；parameter。type是主类型，subtype是子类型，parameter表示可选参数。

1. **application/json**

一种轻量级的数据交互格式

```plain
"indigoTaxRefund": {
	"errorInNoShowTaxRefund": "",
	"fopType": "AG",
	"isRefundProcessed": false,
	"isToShowTaxRefund": false,
	"refundAmount": 0,
	"response": false,
	"taxQueueFlag": false
}
```

1. **application/x-www-form-urlencoded**

通常为form表单提交的默认格式，参数位 k-v 形式通过 & 拼接，URL不可见

```plain
indiGoRetrieveBooking.RecordLocator=T1D2VX
&polymorphicField=GUO&typeSelected=SearchByNAMEFLIGHT
&indiGoRetrieveBooking.IndiGoRegisteredStrategy=Nps.IndiGo.Strategies.IndigoValidatePnrContactNameStrategy%2C+Nps.IndiGo
&indiGoRetrieveBooking.IsToEmailItinerary=false&indiGoRetrieveBooking.EmailAddress=
&indiGoRetrieveBooking.LastName=GUO
```

1. **multipart/form-data**

可以提交非文本数据，例如文件，音频等二进制文件。参数通过boundary标识进行分割

‍

### Refer
‍

