package com.zoyoong.skkumap

import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactorySmall(private val inflater: LayoutInflater) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    private val density = inflater.context.resources.displayMetrics.density

    private val wantedSansMedium: Typeface? = loadFont("wanted_sans_medium")
    private val wantedSansRegular: Typeface? = loadFont("wanted_sans_regular")

    private fun loadFont(name: String): Typeface? = try {
        val resId = inflater.context.resources.getIdentifier(
            name, "font", inflater.context.packageName
        )
        if (resId != 0) {
            androidx.core.content.res.ResourcesCompat.getFont(inflater.context, resId)
        } else null
    } catch (e: Exception) { null }

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = inflater.inflate(
            R.layout.native_ad_small, null
        ) as NativeAdView

        // ── Media ──
        val mediaView = adView.findViewById<MediaView>(R.id.ad_media)
        adView.mediaView = mediaView

        // ── Attribution badge ──
        val attrView = adView.findViewById<TextView>(R.id.ad_attribution)
        val attrBg = GradientDrawable().apply {
            setColor(Color.parseColor("#E8EBED"))
            cornerRadius = 3 * density
        }
        attrView.background = attrBg
        wantedSansRegular?.let { attrView.typeface = it }

        // ── Headline ──
        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        headlineView.text = nativeAd.headline
        wantedSansMedium?.let { headlineView.typeface = it }
        adView.headlineView = headlineView

        // ── Body ──
        val bodyView = adView.findViewById<TextView>(R.id.ad_body)
        bodyView.text = nativeAd.body
        bodyView.visibility = if (nativeAd.body != null) View.VISIBLE else View.GONE
        wantedSansRegular?.let { bodyView.typeface = it }
        adView.bodyView = bodyView

        // ── CTA ──
        val ctaView = adView.findViewById<TextView>(R.id.ad_call_to_action)
        ctaView.text = nativeAd.callToAction
        ctaView.visibility =
            if (nativeAd.callToAction != null) View.VISIBLE else View.GONE
        val ctaBg = GradientDrawable().apply {
            setColor(Color.parseColor("#E8F5EE"))
            cornerRadius = 8 * density
        }
        ctaView.background = ctaBg
        wantedSansMedium?.let { ctaView.typeface = it }
        adView.callToActionView = ctaView

        // ── Icon ──
        val iconView = adView.findViewById<ImageView>(R.id.ad_icon)
        if (nativeAd.icon != null) {
            iconView.setImageDrawable(nativeAd.icon!!.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }
        adView.iconView = iconView

        // ── Advertiser ──
        val advertiserView = adView.findViewById<TextView>(R.id.ad_advertiser)
        advertiserView.text = nativeAd.advertiser
        advertiserView.visibility =
            if (nativeAd.advertiser != null) View.VISIBLE else View.GONE
        wantedSansRegular?.let { advertiserView.typeface = it }
        adView.advertiserView = advertiserView

        adView.setNativeAd(nativeAd)
        return adView
    }
}
