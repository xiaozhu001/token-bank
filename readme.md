### 一、合约
一共分为TokenBank、ERC20、ERC721、Sensitive、BizMarket、UserToken 合约

- TokenBank：主要合约逻辑。其中实现了创建token以及合约的基本信息存储。
- ERC20、ERC721：两个token的标准合约
- Sensitive：敏感词合约
- BizMarket：营销合约，配置广告等业务逻辑
- UserToken：用户token合约。

### 二、接口文档

#### 1、TokenBank 合约
// 查询首页列表
- function getHomeTokenList(uint index, uint pageSize) public view returns(address[] memory tokens, uint[] memory indexs)

// 查询顶部token
- function getTopToken(uint index, uint pageSize) public view returns(address[] memory, string[] memory)

// 添加顶部token
- function addTopToken(address token, string memory note) public

// 删除顶部token
- function removeTopToken(uint index) public

// 获取token详细信息
- function getTokenInfo(address userAccount, address tokenAddr) public view returns(TokenInfoModel.TokenInfo memory tokenInfo, bool collection)

// 根据简称获取token信息
- function getTokenByShorthandName(string memory shorthandName, address userAccount) public view returns(TokenInfoModel.TokenInfo memory tokenInfo, bool collection) 

// 校验简称是否可用
- function checkShorthandName(string memory shorthandName) public view returns(bool result)

// 发布token
- function publishToken(TokenInfoModel.CreateToken memory createToken) public

// 删除token （合约内部使用）
- function removeToken(string memory shorthandName) public

#### 2、 UserToken 合约
// 获取用户token列表
- function getUserTokenList(uint8 _option, address _userAccount, uint index, uint pageSize) public view returns(address[] memory itemList, uint[] memory indexList)

// 收藏token
- function collectionToken(address _token, uint _option) public

// 添加我的token （合约内部使用）
- function addMyToken(address _token, address _userAccount) external

// 是否收藏合约
- function isCollection(address account, address token) external override view returns(bool)

#### 3、Sensitive 合约

// 添加敏感词
- function addWords(string memory _words) public

// 校验敏感词
- function checkWords(string calldata _words)  external override view returns(bool result)

// 移除敏感词
- function removeWord(string memory _words) public

#### 4、BizMarket 合约
// 设置广告信息
- function setBanner(string memory _bannerListStr) public

// 获取广告信息
- function getBanner() public view returns(string memory)

// 设置热搜词
- function setHotSearch(string memory _hotSearchListStr) public

// 获取热搜词
- function getHotSearch() public view returns(string memory)

#### 5、Token模型
~~~
    struct TokenInfo {
        string tokenName;
        string shorthandName;
        address token;
        address owner;
        uint total;
        uint totalSupply;
        uint holderNum;
        uint haveNum;
        string img;
        bool burning;
        bool increase;
        uint decimals;
        string note;
        string attribute;
        uint createTime;
    }
    // ["ERC20","ERC20", 1000,"/abc",false,false,10,"abc","def"]
    struct CreateToken {
        string tokenName;
        string shorthandName;
        uint total;
        string img;
        bool burning;
        bool increase;
        uint decimals;
        string note;
        string attribute;
    }
~~~

### 三、测试数据
管理员账户： 0x0086dcf09d1bd311f36df5674730847a7900a7f2af679167a5fae2699bde9e44

合约地址：
- 0x867c62c62ceccac465f141daa655f7b147c57d26  tokenbank 合约
- 0x88f3c7a1ab7068aaf6df90649ab8388ac3e9ae85  userToken 合约
- 0x8ad61b96352cb98564e606319b1423e66dd101ba  Sensitive 合约
- 0x8004e3e3b41d72eb7a58529f68e119b0e101dba1  BizMarket 合约

### 四、合约abi

userToken abi信息
~~~
[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_tokenBankAddress",
          "type": "address"
        }
      ],
      "name": "setTokenBank",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint8",
          "name": "_option",
          "type": "uint8"
        },
        {
          "internalType": "address",
          "name": "_userAccount",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "index",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "pageSize",
          "type": "uint256"
        }
      ],
      "name": "getUserTokenList",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "itemList",
          "type": "address[]"
        },
        {
          "internalType": "uint256[]",
          "name": "indexList",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_token",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "_option",
          "type": "uint256"
        }
      ],
      "name": "collectionToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_token",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_userAccount",
          "type": "address"
        }
      ],
      "name": "addMyToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "account",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "token",
          "type": "address"
        }
      ],
      "name": "isCollection",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
~~~

Sensitive abi信息

~~~
[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "string",
          "name": "_words",
          "type": "string"
        }
      ],
      "name": "del",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "contract ITokenBank",
          "name": "_tokenBank",
          "type": "address"
        }
      ],
      "name": "setTokenBank",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_words",
          "type": "string"
        }
      ],
      "name": "addWords",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_words",
          "type": "string"
        }
      ],
      "name": "checkWords",
      "outputs": [
        {
          "internalType": "bool",
          "name": "result",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_words",
          "type": "string"
        }
      ],
      "name": "removeWord",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]
~~~

tokenbank abi信息
~~~
[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "contract ISensitive",
          "name": "sensitiveAddr",
          "type": "address"
        },
        {
          "internalType": "contract IUserToken",
          "name": "userTokenAddr",
          "type": "address"
        }
      ],
      "name": "setContract",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "index",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "pageSize",
          "type": "uint256"
        }
      ],
      "name": "getTopToken",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "",
          "type": "address[]"
        },
        {
          "internalType": "string[]",
          "name": "",
          "type": "string[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "token",
          "type": "address"
        },
        {
          "internalType": "string",
          "name": "note",
          "type": "string"
        }
      ],
      "name": "addTopToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "index",
          "type": "uint256"
        }
      ],
      "name": "removeTopToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "index",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "pageSize",
          "type": "uint256"
        }
      ],
      "name": "getHomeTokenList",
      "outputs": [
        {
          "internalType": "address[]",
          "name": "tokens",
          "type": "address[]"
        },
        {
          "internalType": "uint256[]",
          "name": "indexs",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "userAccount",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "tokenAddr",
          "type": "address"
        }
      ],
      "name": "getTokenInfo",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "tokenName",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "shorthandName",
              "type": "string"
            },
            {
              "internalType": "address",
              "name": "token",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "owner",
              "type": "address"
            },
            {
              "internalType": "uint256",
              "name": "total",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "totalSupply",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "holderNum",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "haveNum",
              "type": "uint256"
            },
            {
              "internalType": "string",
              "name": "img",
              "type": "string"
            },
            {
              "internalType": "bool",
              "name": "burning",
              "type": "bool"
            },
            {
              "internalType": "bool",
              "name": "increase",
              "type": "bool"
            },
            {
              "internalType": "uint256",
              "name": "decimals",
              "type": "uint256"
            },
            {
              "internalType": "string",
              "name": "note",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "attribute",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "createTime",
              "type": "uint256"
            }
          ],
          "internalType": "struct TokenInfoModel.TokenInfo",
          "name": "tokenInfo",
          "type": "tuple"
        },
        {
          "internalType": "bool",
          "name": "collection",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "shorthandName",
          "type": "string"
        },
        {
          "internalType": "address",
          "name": "userAccount",
          "type": "address"
        }
      ],
      "name": "getTokenByShorthandName",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "tokenName",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "shorthandName",
              "type": "string"
            },
            {
              "internalType": "address",
              "name": "token",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "owner",
              "type": "address"
            },
            {
              "internalType": "uint256",
              "name": "total",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "totalSupply",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "holderNum",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "haveNum",
              "type": "uint256"
            },
            {
              "internalType": "string",
              "name": "img",
              "type": "string"
            },
            {
              "internalType": "bool",
              "name": "burning",
              "type": "bool"
            },
            {
              "internalType": "bool",
              "name": "increase",
              "type": "bool"
            },
            {
              "internalType": "uint256",
              "name": "decimals",
              "type": "uint256"
            },
            {
              "internalType": "string",
              "name": "note",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "attribute",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "createTime",
              "type": "uint256"
            }
          ],
          "internalType": "struct TokenInfoModel.TokenInfo",
          "name": "tokenInfo",
          "type": "tuple"
        },
        {
          "internalType": "bool",
          "name": "collection",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "shorthandName",
          "type": "string"
        }
      ],
      "name": "checkShorthandName",
      "outputs": [
        {
          "internalType": "bool",
          "name": "result",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "tokenName",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "shorthandName",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "total",
              "type": "uint256"
            },
            {
              "internalType": "string",
              "name": "img",
              "type": "string"
            },
            {
              "internalType": "bool",
              "name": "burning",
              "type": "bool"
            },
            {
              "internalType": "bool",
              "name": "increase",
              "type": "bool"
            },
            {
              "internalType": "uint256",
              "name": "decimals",
              "type": "uint256"
            },
            {
              "internalType": "string",
              "name": "note",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "attribute",
              "type": "string"
            }
          ],
          "internalType": "struct TokenInfoModel.CreateToken",
          "name": "createToken",
          "type": "tuple"
        }
      ],
      "name": "publishToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "shorthandName",
          "type": "string"
        }
      ],
      "name": "removeToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]
~~~

BizMarket abi信息
~~~
[
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_bannerListStr",
          "type": "string"
        }
      ],
      "name": "setBanner",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getBanner",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_hotSearchListStr",
          "type": "string"
        }
      ],
      "name": "setHotSearch",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getHotSearch",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
~~~

