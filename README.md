(현재는 종료된 프로젝트입니다.)

# Cuniverse Hub (NFT 거래 중개 스마트 콘트랙트)

## 소개
NFT 거래 중개를 위한 스마트 콘트랙트입니다. EIP-712 서명, ERC-721 Approval, 거래 시작/마감 시간, 금액 등 거래에 필요한 모든 요소를 검증 후, 거래가 이루이지도록 설계하였습니다. 
(해당 프로젝트는 모두 Ethereum Sepolia 네트워크에서 진행됩니다.)

## Etherscan 주소
https://sepolia.etherscan.io/address/0x41aae050DdCDf5894099B9d56d863a201Dc09807

## 거래 프로세스
```text
1. 판매자가 NFT 판매 등록
  - Contract, Token Id, 가격, 거래 시작/마감 시간을 입력한 후 거래 등록
2. ERC -721 Approval이 활성화 되어있지 않다면, setApproval 트랜젝션 실행
3. 입력한 정보를 토대로 EIP -712 서명(eth_signTypedData_v4)
4. Off Chain에 거래정보 저장
5. 구매자가 거래를 요청하면 해당 콘트랙트의 proceedOrder 트랜젝션 실행
6. proceedOrder 메서드의 모든 검증이 통과되면
  - ERC -721 transferFrom 트렌잭션 실행
  - 판매자에게 판매금액 송금
  - 창작자에게 Royalty 송금
  - 거래 플랫폼 지갑에 거래 수수료 송금
```

## Order Struct
<img width="242" alt="스크린샷 2023-09-07 오후 4 22 50" src="https://github.com/ttap0704/cuniverse-hub/assets/81610009/6a7a0af7-8982-44ee-9b5f-f3872a0660d3">

## EIP-712 Verify
<img width="526" alt="스크린샷 2023-09-07 오후 4 22 30" src="https://github.com/ttap0704/cuniverse-hub/assets/81610009/92f9600c-8419-4219-9b61-221abc28db94">
