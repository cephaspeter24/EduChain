;; Credential NFT Contract

(define-non-fungible-token credential-nft uint)

(define-data-var last-token-id uint u0)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

(define-map token-uris {token-id: uint} {uri: (string-utf8 256)})
(define-map token-metadata
  {token-id: uint}
  {
    institution: (string-utf8 100),
    credential-type: (string-utf8 50),
    issue-date: uint,
    expiration-date: uint
  }
)

(define-read-only (get-last-token-id)
  (ok (var-get last-token-id)))

(define-public (mint (recipient principal) (uri (string-utf8 256)) (institution (string-utf8 100)) (credential-type (string-utf8 50)) (issue-date uint) (expiration-date uint))
  (let
    ((token-id (+ (var-get last-token-id) u1)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (try! (nft-mint? credential-nft token-id recipient))
    (map-set token-uris {token-id: token-id} {uri: uri})
    (map-set token-metadata
      {token-id: token-id}
      {
        institution: institution,
        credential-type: credential-type,
        issue-date: issue-date,
        expiration-date: expiration-date
      }
    )
    (var-set last-token-id token-id)
    (ok token-id)))

(define-read-only (get-token-uri (token-id uint))
  (ok (get uri (unwrap! (map-get? token-uris {token-id: token-id}) err-not-found))))

(define-read-only (get-token-metadata (token-id uint))
  (ok (unwrap! (map-get? token-metadata {token-id: token-id}) err-not-found)))

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-owner-only)
    (nft-transfer? credential-nft token-id sender recipient)))

