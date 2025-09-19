
#if VQ_LOGGER

import Varioqub
#if VQ_MODULES
import VarioqubLogger
#endif

public let varioqubLoggerString = LoggerModule(rawValue: "com.varioqub")
let varioqubLogger = Logger(moduleName: varioqubLoggerString)

#else
import Logging
public let varioqubLoggerString = "com.varioqub"
let varioqubLogger = Logger(label: varioqubLoggerString)
#endif
