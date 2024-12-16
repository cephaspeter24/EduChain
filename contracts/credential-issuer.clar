;; Credential Issuer Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))

(define-map authorized-institutions principal bool)

(define-public (add-authorized-institution (institution principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set authorized-institutions institution true))))

(define-public (remove-authorized-institution (institution principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-delete authorized-institutions institution))))

(define-public (issue-credential
    (recipient principal)
    (uri (string-utf8 256))
    (institution (string-utf8 100))
    (credential-type (string-utf8 50))
    (expiration-date uint))
  (begin
    (asserts! (default-to false (map-get? authorized-institutions tx-sender)) err-not-authorized)
    (ok {
      recipient: recipient,
      uri: uri,
      institution: institution,
      credential-type: credential-type,
      issue-date: block-height,
      expiration-date: expiration-date
    })))

