import google_mobile_ads
import GoogleMobileAds

class NativeAdFactorySmall: NSObject, FLTNativeAdFactory {

    // ── Toss-style colors ──
    private let textPrimary = UIColor(red: 25/255.0, green: 31/255.0, blue: 40/255.0, alpha: 1)     // #191F28
    private let textSecondary = UIColor(red: 78/255.0, green: 89/255.0, blue: 104/255.0, alpha: 1)   // #4E5968
    private let textTertiary = UIColor(red: 139/255.0, green: 149/255.0, blue: 161/255.0, alpha: 1)  // #8B95A1
    private let bgGrey = UIColor(red: 242/255.0, green: 244/255.0, blue: 246/255.0, alpha: 1)        // #F2F4F6
    private let attrBg = UIColor(red: 232/255.0, green: 235/255.0, blue: 237/255.0, alpha: 1)        // #E8EBED
    private let brandColor = UIColor(red: 26/255.0, green: 127/255.0, blue: 75/255.0, alpha: 1)      // #1A7F4B
    private let brandLight = UIColor(red: 232/255.0, green: 245/255.0, blue: 238/255.0, alpha: 1)    // #E8F5EE

    // ── WantedSans with system fallback ──
    private func wantedSans(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let name = weight == .medium ? "WantedSans-Medium" : "WantedSans-Regular"
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }

    func createNativeAd(
        _ nativeAd: GADNativeAd,
        customOptions: [AnyHashable: Any]? = nil
    ) -> GADNativeAdView? {
        let adView = GADNativeAdView()
        adView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        adView.backgroundColor = .white

        // ── Container with padding ──
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: adView.topAnchor, constant: 6),
            container.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -6),
        ])

        // ── MediaView (120x120, left, rounded 12dp) ──
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.contentMode = .scaleAspectFill
        mediaView.clipsToBounds = true
        mediaView.layer.cornerRadius = 12
        mediaView.backgroundColor = bgGrey
        container.addSubview(mediaView)
        adView.mediaView = mediaView

        NSLayoutConstraint.activate([
            mediaView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            mediaView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            mediaView.widthAnchor.constraint(equalToConstant: 120),
            mediaView.heightAnchor.constraint(equalToConstant: 120),
        ])

        // ── Right column ──
        let rightColumn = UIStackView()
        rightColumn.translatesAutoresizingMaskIntoConstraints = false
        rightColumn.axis = .vertical
        rightColumn.spacing = 2
        rightColumn.alignment = .fill
        container.addSubview(rightColumn)

        NSLayoutConstraint.activate([
            rightColumn.leadingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: 12),
            rightColumn.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rightColumn.topAnchor.constraint(equalTo: container.topAnchor),
            rightColumn.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        // ── Attribution label ──
        let attributionLabel = PaddedLabel()
        attributionLabel.text = "AD"
        attributionLabel.font = wantedSans(size: 9)
        attributionLabel.textColor = textTertiary
        attributionLabel.backgroundColor = attrBg
        attributionLabel.textAlignment = .center
        attributionLabel.layer.cornerRadius = 3
        attributionLabel.clipsToBounds = true
        attributionLabel.edgeInsets = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
        attributionLabel.setContentHuggingPriority(.required, for: .horizontal)

        // Wrap in a left-aligned container so it doesn't stretch
        let attrRow = UIStackView(arrangedSubviews: [attributionLabel, UIView()])
        attrRow.axis = .horizontal
        rightColumn.addArrangedSubview(attrRow)

        // ── Headline ──
        let headlineLabel = UILabel()
        headlineLabel.text = nativeAd.headline
        headlineLabel.font = wantedSans(size: 15, weight: .medium)
        headlineLabel.textColor = textPrimary
        headlineLabel.numberOfLines = 2
        adView.headlineView = headlineLabel
        rightColumn.addArrangedSubview(headlineLabel)

        // ── Body ──
        let bodyLabel = UILabel()
        bodyLabel.text = nativeAd.body
        bodyLabel.font = wantedSans(size: 13)
        bodyLabel.textColor = textSecondary
        bodyLabel.numberOfLines = 2
        bodyLabel.isHidden = (nativeAd.body == nil)
        adView.bodyView = bodyLabel
        rightColumn.addArrangedSubview(bodyLabel)

        // ── Spacer ──
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        rightColumn.addArrangedSubview(spacer)

        // ── Icon + Advertiser row ──
        let advertiserRow = UIStackView()
        advertiserRow.axis = .horizontal
        advertiserRow.spacing = 4
        advertiserRow.alignment = .center

        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        if let icon = nativeAd.icon?.image {
            iconView.image = icon
        } else {
            iconView.isHidden = true
        }
        adView.iconView = iconView
        advertiserRow.addArrangedSubview(iconView)

        let advertiserLabel = UILabel()
        advertiserLabel.text = nativeAd.advertiser
        advertiserLabel.font = wantedSans(size: 11)
        advertiserLabel.textColor = textTertiary
        advertiserLabel.numberOfLines = 1
        advertiserLabel.isHidden = (nativeAd.advertiser == nil)
        adView.advertiserView = advertiserLabel
        advertiserRow.addArrangedSubview(advertiserLabel)

        rightColumn.addArrangedSubview(advertiserRow)

        // ── CTA Button ──
        let ctaButton = UIButton(type: .system)
        ctaButton.setTitle(nativeAd.callToAction, for: .normal)
        ctaButton.setTitleColor(brandColor, for: .normal)
        ctaButton.titleLabel?.font = wantedSans(size: 13, weight: .medium)
        ctaButton.backgroundColor = brandLight
        ctaButton.layer.cornerRadius = 8
        ctaButton.clipsToBounds = true
        ctaButton.isUserInteractionEnabled = false
        ctaButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        ctaButton.isHidden = (nativeAd.callToAction == nil)
        adView.callToActionView = ctaButton
        rightColumn.addArrangedSubview(ctaButton)

        // ── Spacing before CTA ──
        rightColumn.setCustomSpacing(4, after: advertiserRow)

        adView.nativeAd = nativeAd
        return adView
    }
}

// ── Helper: UILabel with padding ──
private class PaddedLabel: UILabel {
    var edgeInsets = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + edgeInsets.left + edgeInsets.right,
            height: size.height + edgeInsets.top + edgeInsets.bottom
        )
    }
}
